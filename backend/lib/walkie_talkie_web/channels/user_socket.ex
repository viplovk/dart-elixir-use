defmodule WalkieTalkieWeb.UserSocket do
  @moduledoc """
  Phoenix Channels UserSocket.
  Manages client socket lifecycle, user authentication/ephemeral token assignment,
  and routes channel subscriptions to RoomChannel and VoiceChannel.
  """
  use Phoenix.Socket

  # Channels
  channel "room:lobby", WalkieTalkieWeb.RoomChannel
  channel "room:*", WalkieTalkieWeb.RoomChannel
  channel "voice:*", WalkieTalkieWeb.VoiceChannel

  @impl true
  def connect(params, socket, _connect_info) do
    # Ephemeral user ID generation or extraction
    user_id = params["user_id"] || "usr_#{:crypto.strong_rand_bytes(4) |> Base.encode16(case: :lower)}"
    username = params["username"] || "Operator-#{String.slice(user_id, 4, 4)}"

    socket =
      socket
      |> assign(:user_id, user_id)
      |> assign(:username, username)
      |> assign(:connected_at, System.system_time(:millisecond))

    {:ok, socket}
  end

  @impl true
  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
end
