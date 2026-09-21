defmodule WalkieTalkie.Rooms.Coordinator do
  @moduledoc """
  Coordinates room lifecycle across the cluster.
  Handles room creation, code generation, lookup, and periodic sweep of stale ETS records.
  """
  use GenServer
  require Logger

  alias WalkieTalkie.Rooms.Room

  # Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def create_room(attrs \\ %{}) do
    GenServer.call(__MODULE__, {:create_room, attrs})
  end

  def find_room_by_code(code) when is_binary(code) do
    sanitized = String.trim(code) |> String.upcase()
    case :ets.lookup(:ephemeral_rooms, sanitized) do
      [{^sanitized, room_id, _name, expires_at}] ->
        now = System.system_time(:second)
        if expires_at > now do
          {:ok, room_id}
        else
          :ets.delete(:ephemeral_rooms, sanitized)
          {:error, :expired}
        end

      [] ->
        {:error, :not_found}
    end
  end

  def list_active_rooms do
    now = System.system_time(:second)
    :ets.tab2list(:ephemeral_rooms)
    |> Enum.filter(fn {_code, _id, _name, expires_at} -> expires_at > now end)
    |> Enum.map(fn {code, id, name, expires_at} ->
      %{
        room_id: id,
        room_code: code,
        name: name,
        remaining_seconds: max(0, expires_at - now)
      }
    end)
  end

  # Server Callbacks

  @impl true
  def init(_opts) do
    # Run a sweep every 60 seconds to prune stale room metadata
    schedule_sweep()
    {:ok, %{}}
  end

  @impl true
  def handle_call({:create_room, attrs}, _from, state) do
    room_id = Map.get(attrs, :room_id) || "room_#{UUID.uuid4()}"
    room_code = Map.get(attrs, :room_code) || generate_unique_code()
    name = Map.get(attrs, :name) || "Tactical #{room_code}"
    ttl = Map.get(attrs, :ttl_seconds) || 1800
    max_participants = Map.get(attrs, :max_participants) || 16
    voice_enabled = Map.get(attrs, :voice_enabled, true)
    chat_enabled = Map.get(attrs, :chat_enabled, true)

    opts = [
      room_id: room_id,
      room_code: room_code,
      name: name,
      ttl_seconds: ttl,
      max_participants: max_participants,
      voice_enabled: voice_enabled,
      chat_enabled: chat_enabled
    ]

    case DynamicSupervisor.start_child(WalkieTalkie.RoomSupervisor, {Room, opts}) do
      {:ok, _pid} ->
        Logger.info("[Coordinator] Started room #{room_id} (#{room_code})")
        {:reply, {:ok, %{room_id: room_id, room_code: room_code, name: name, ttl_seconds: ttl}}, state}

      {:error, reason} ->
        Logger.error("[Coordinator] Failed to start room #{room_id}: #{inspect(reason)}")
        {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_info(:sweep, state) do
    now = System.system_time(:second)
    :ets.tab2list(:ephemeral_rooms)
    |> Enum.each(fn {code, _id, _name, expires_at} ->
      if expires_at <= now do
        :ets.delete(:ephemeral_rooms, code)
      end
    end)

    schedule_sweep()
    {:noreply, state}
  end

  # Helpers

  defp schedule_sweep do
    Process.send_after(self(), :sweep, 60_000)
  end

  defp generate_unique_code do
    prefixes = ["NIGHT", "NOVA", "ECHO", "HAWK", "DELTA", "APEX", "PULSE", "VIPER", "TITAN", "GHOST"]
    code = "#{Enum.random(prefixes)}-#{:crypto.strong_rand_bytes(2) |> Base.encode16(case: :upper)}"

    case :ets.lookup(:ephemeral_rooms, code) do
      [] -> code
      _ -> generate_unique_code()
    end
  end
end
