defmodule WalkieTalkieWeb.RoomChannel do
  @moduledoc """
  Phoenix Channel handling room lifecycle, participant presence, encrypted text messaging,
  typing indicators, and ephemeral room expiration notifications.
  """
  use WalkieTalkieWeb, :channel
  require Logger

  alias WalkieTalkie.Rooms
  alias WalkieTalkie.Messaging
  alias WalkieTalkieWeb.Presence

  @impl true
  def join("room:lobby", _payload, socket) do
    rooms = Rooms.list_active_rooms()
    {:ok, %{active_rooms: rooms}, socket}
  end

  @impl true
  def join("room:" <> room_id, payload, socket) do
    user = %{
      id: socket.assigns.user_id,
      username: payload["username"] || socket.assigns.username,
      avatar_seed: payload["avatar_seed"] || socket.assigns.user_id
    }

    case Rooms.join_room(room_id, user) do
      {:ok, _joined_user} ->
        socket =
          socket
          |> assign(:room_id, room_id)
          |> assign(:user, user)

        send(self(), :after_join)
        {:ok, %{status: "connected", room_id: room_id, user_id: user.id}, socket}

      {:error, :room_full} ->
        {:error, %{reason: "Room reached maximum participant capacity"}}

      {:error, :not_found} ->
        {:error, %{reason: "Room not found or expired"}}
    end
  end

  @impl true
  def handle_info(:after_join, socket) do
    room_id = socket.assigns.room_id
    user = socket.assigns.user

    # Track Phoenix Presence for real-time participant state
    {:ok, _} =
      Presence.track_user(socket, user.id, %{
        username: user.username,
        avatar_seed: user.avatar_seed,
        online: true,
        microphone_state: "unmuted",
        speaking: false,
        ptt_active: false,
        connection_quality: "excellent"
      })

    # Push full presence state to the joining user
    push(socket, "presence_state", Presence.list(socket))

    # Push room snapshot (messages, remaining time, metadata)
    case Rooms.get_room_state(room_id) do
      {:ok, state} ->
        push(socket, "room_state", state)

      _ ->
        :ok
    end

    {:noreply, socket}
  end

  # Live Text Chat Message
  @impl true
  def handle_in("send_message", payload, socket) do
    room_id = socket.assigns.room_id
    user = socket.assigns.user

    message = Messaging.build_message(%{
      room_id: room_id,
      sender_id: user.id,
      sender_name: user.username,
      encrypted_payload: payload["encrypted_payload"],
      nonce: payload["nonce"],
      timestamp: System.system_time(:millisecond),
      is_system: false
    })

    case Rooms.post_message(room_id, message) do
      {:ok, saved_msg} ->
        broadcast!(socket, "new_message", saved_msg)
        {:reply, {:ok, %{status: "delivered", message_id: saved_msg.id}}, socket}

      {:error, reason} ->
        {:reply, {:error, %{reason: inspect(reason)}}, socket}
    end
  end

  # Typing indicators
  @impl true
  def handle_in("typing_start", _payload, socket) do
    broadcast_from!(socket, "user_typing_start", %{
      user_id: socket.assigns.user.id,
      username: socket.assigns.user.username
    })
    {:reply, :ok, socket}
  end

  @impl true
  def handle_in("typing_stop", _payload, socket) do
    broadcast_from!(socket, "user_typing_stop", %{
      user_id: socket.assigns.user.id
    })
    {:reply, :ok, socket}
  end

  # Update presence profile (e.g. connection quality updates)
  @impl true
  def handle_in("update_presence", payload, socket) do
    user_id = socket.assigns.user.id
    Presence.update_voice_state(socket, user_id, payload)
    {:reply, :ok, socket}
  end

  # Graceful room leave
  @impl true
  def handle_in("leave_room", _payload, socket) do
    Rooms.leave_room(socket.assigns.room_id, socket.assigns.user.id)
    {:reply, :ok, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    if Map.has_key?(socket.assigns, :room_id) do
      Rooms.leave_room(socket.assigns.room_id, socket.assigns.user.id)
    end
    :ok
  end
end
