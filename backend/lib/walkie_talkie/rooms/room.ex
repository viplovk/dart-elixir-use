defmodule WalkieTalkie.Rooms.Room do
  @moduledoc """
  GenServer representing an individual ephemeral walkie-talkie room.
  Handles:
  - Lifecycle: creation, countdown, expiration, and auto-destruction
  - Participant state: join, leave, voice PTT states
  - In-memory ephemeral message buffer (not persisted to disk)
  - PubSub broadcasts on room lifecycle events
  """
  use GenServer, restart: :transient
  require Logger

  alias Phoenix.PubSub

  defstruct [
    :room_id,
    :room_code,
    :name,
    :created_at,
    :expires_at,
    :expiration_timer,
    :empty_grace_timer,
    participants: %{},
    voice_state: %{
      active_speaker: nil,
      ptt_holders: MapSet.new(),
      muted_users: MapSet.new()
    },
    messages: [],
    max_participants: 16,
    voice_enabled: true,
    chat_enabled: true,
    ttl_seconds: 1800
  ]

  # Client API

  def start_link(opts) do
    room_id = Keyword.fetch!(opts, :room_id)
    GenServer.start_link(__MODULE__, opts, name: via_tuple(room_id))
  end

  def get_state(room_id) do
    GenServer.call(via_tuple(room_id), :get_state)
  end

  def join(room_id, user) do
    GenServer.call(via_tuple(room_id), {:join, user})
  end

  def leave(room_id, user_id) do
    GenServer.call(via_tuple(room_id), {:leave, user_id})
  end

  def post_message(room_id, message) do
    GenServer.call(via_tuple(room_id), {:post_message, message})
  end

  def start_ptt(room_id, user_id) do
    GenServer.call(via_tuple(room_id), {:start_ptt, user_id})
  end

  def stop_ptt(room_id, user_id) do
    GenServer.call(via_tuple(room_id), {:stop_ptt, user_id})
  end

  def toggle_mute(room_id, user_id) do
    GenServer.call(via_tuple(room_id), {:toggle_mute, user_id})
  end

  def destroy(room_id) do
    GenServer.call(via_tuple(room_id), :destroy)
  end

  def via_tuple(room_id) do
    {:via, Registry, {WalkieTalkie.RoomRegistry, room_id}}
  end

  # Server Callbacks

  @impl true
  def init(opts) do
    room_id = Keyword.fetch!(opts, :room_id)
    room_code = Keyword.get(opts, :room_code, generate_code())
    name = Keyword.get(opts, :name, "Room #{room_code}")
    ttl_seconds = Keyword.get(opts, :ttl_seconds, 1800)
    max_participants = Keyword.get(opts, :max_participants, 16)
    voice_enabled = Keyword.get(opts, :voice_enabled, true)
    chat_enabled = Keyword.get(opts, :chat_enabled, true)

    now = System.system_time(:second)
    expires_at = now + ttl_seconds

    # Schedule hard expiration
    timer_ref = Process.send_after(self(), :expire, ttl_seconds * 1000)

    state = %__MODULE__{
      room_id: room_id,
      room_code: room_code,
      name: name,
      created_at: now,
      expires_at: expires_at,
      expiration_timer: timer_ref,
      ttl_seconds: ttl_seconds,
      max_participants: max_participants,
      voice_enabled: voice_enabled,
      chat_enabled: chat_enabled
    }

    # Store fast index in ETS for code lookup
    :ets.insert(:ephemeral_rooms, {room_code, room_id, name, expires_at})

    Logger.info("[Room #{room_id}] Created with code #{room_code}, expires in #{ttl_seconds}s")
    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    safe_state = %{
      room_id: state.room_id,
      room_code: state.room_code,
      name: state.name,
      created_at: state.created_at,
      expires_at: state.expires_at,
      remaining_seconds: max(0, state.expires_at - System.system_time(:second)),
      participant_count: map_size(state.participants),
      participants: Map.values(state.participants),
      voice_state: %{
        active_speaker: state.voice_state.active_speaker,
        ptt_holders: MapSet.to_list(state.voice_state.ptt_holders),
        muted_users: MapSet.to_list(state.voice_state.muted_users)
      },
      messages: Enum.take(state.messages, 50),
      max_participants: state.max_participants,
      voice_enabled: state.voice_enabled,
      chat_enabled: state.chat_enabled
    }
    {:reply, {:ok, safe_state}, state}
  end

  @impl true
  def handle_call({:join, user}, _from, state) do
    cond do
      map_size(state.participants) >= state.max_participants ->
        {:reply, {:error, :room_full}, state}

      true ->
        # Cancel empty room grace timer if active
        if state.empty_grace_timer do
          Process.cancel_timer(state.empty_grace_timer)
        end

        updated_participants = Map.put(state.participants, user.id, user)
        new_state = %{state | participants: updated_participants, empty_grace_timer: nil}

        broadcast_event(state.room_id, "user_joined", %{
          user: user,
          participant_count: map_size(updated_participants)
        })

        {:reply, {:ok, user}, new_state}
    end
  end

  @impl true
  def handle_call({:leave, user_id}, _from, state) do
    updated_participants = Map.delete(state.participants, user_id)
    new_ptt = MapSet.delete(state.voice_state.ptt_holders, user_id)
    new_muted = MapSet.delete(state.voice_state.muted_users, user_id)
    new_active_speaker =
      if state.voice_state.active_speaker == user_id, do: nil, else: state.voice_state.active_speaker

    new_voice_state = %{
      state.voice_state
      | ptt_holders: new_ptt,
        muted_users: new_muted,
        active_speaker: new_active_speaker
    }

    # If empty, start 2-minute grace countdown before destroying
    grace_timer =
      if map_size(updated_participants) == 0 do
        Process.send_after(self(), :grace_expire, 120 * 1000)
      else
        state.empty_grace_timer
      end

    new_state = %{
      state
      | participants: updated_participants,
        voice_state: new_voice_state,
        empty_grace_timer: grace_timer
    }

    broadcast_event(state.room_id, "user_left", %{
      user_id: user_id,
      participant_count: map_size(updated_participants)
    })

    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call({:post_message, message}, _from, state) do
    # Prepend message (ring buffer limited to 100 ephemeral messages)
    updated_messages = [message | Enum.take(state.messages, 99)]
    new_state = %{state | messages: updated_messages}

    broadcast_event(state.room_id, "new_message", message)
    {:reply, {:ok, message}, new_state}
  end

  @impl true
  def handle_call({:start_ptt, user_id}, _from, state) do
    new_ptt = MapSet.put(state.voice_state.ptt_holders, user_id)
    # First one holding PTT becomes active speaker
    new_active = state.voice_state.active_speaker || user_id
    new_voice = %{state.voice_state | ptt_holders: new_ptt, active_speaker: new_active}
    new_state = %{state | voice_state: new_voice}

    broadcast_voice_event(state.room_id, "speaking_start", %{
      user_id: user_id,
      active_speaker: new_active
    })

    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call({:stop_ptt, user_id}, _from, state) do
    new_ptt = MapSet.delete(state.voice_state.ptt_holders, user_id)
    new_active =
      if state.voice_state.active_speaker == user_id do
        Enum.at(MapSet.to_list(new_ptt), 0)
      else
        state.voice_state.active_speaker
      end

    new_voice = %{state.voice_state | ptt_holders: new_ptt, active_speaker: new_active}
    new_state = %{state | voice_state: new_voice}

    broadcast_voice_event(state.room_id, "speaking_stop", %{
      user_id: user_id,
      active_speaker: new_active
    })

    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call({:toggle_mute, user_id}, _from, state) do
    is_muted = MapSet.member?(state.voice_state.muted_users, user_id)
    new_muted =
      if is_muted do
        MapSet.delete(state.voice_state.muted_users, user_id)
      else
        MapSet.put(state.voice_state.muted_users, user_id)
      end

    new_voice = %{state.voice_state | muted_users: new_muted}
    new_state = %{state | voice_state: new_voice}

    event = if is_muted, do: "unmuted", else: "muted"
    broadcast_voice_event(state.room_id, event, %{user_id: user_id})

    {:reply, {:ok, !is_muted}, new_state}
  end

  @impl true
  def handle_call(:destroy, _from, state) do
    {:stop, :normal, :ok, state}
  end

  @impl true
  def handle_info(:expire, state) do
    Logger.info("[Room #{state.room_id}] Expired after #{state.ttl_seconds}s. Terminating session.")
    broadcast_event(state.room_id, "room_expired", %{
      reason: "Room reached maximum ephemeral lifetime",
      room_id: state.room_id
    })
    {:stop, :normal, state}
  end

  @impl true
  def handle_info(:grace_expire, state) do
    if map_size(state.participants) == 0 do
      Logger.info("[Room #{state.room_id}] Empty room grace period ended. Cleaning up.")
      {:stop, :normal, state}
    else
      {:noreply, %{state | empty_grace_timer: nil}}
    end
  end

  @impl true
  def terminate(_reason, state) do
    # Remove from ETS cache
    :ets.delete(:ephemeral_rooms, state.room_code)
    PubSub.broadcast(WalkieTalkie.PubSub, "room:lobby", {:room_destroyed, state.room_id})
    :ok
  end

  # Helpers

  defp broadcast_event(room_id, event, payload) do
    PubSub.broadcast(WalkieTalkie.PubSub, "room:#{room_id}", {String.to_atom(event), payload})
  end

  defp broadcast_voice_event(room_id, event, payload) do
    PubSub.broadcast(WalkieTalkie.PubSub, "voice:#{room_id}", {String.to_atom(event), payload})
  end

  defp generate_code do
    prefixes = ["NIGHT", "NOVA", "ECHO", "HAWK", "DELTA", "APEX", "PULSE", "VIPER"]
    suffix = :crypto.strong_rand_bytes(3) |> Base.encode16(case: :upper)
    "#{Enum.random(prefixes)}-#{suffix}"
  end
end
