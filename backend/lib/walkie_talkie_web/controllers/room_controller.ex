defmodule WalkieTalkieWeb.RoomController do
  @moduledoc """
  Phoenix Controller for REST management of ephemeral rooms and WebRTC ICE configuration.
  """
  use WalkieTalkieWeb, :controller
  alias WalkieTalkie.Rooms

  def health(conn, _params) do
    json(conn, %{
      status: "online",
      service: "walkie_talkie_phoenix",
      runtime: "Elixir/OTP",
      timestamp: System.system_time(:millisecond)
    })
  end

  def index(conn, _params) do
    rooms = Rooms.list_active_rooms()
    json(conn, %{rooms: rooms, count: length(rooms)})
  end

  def create(conn, params) do
    attrs = %{
      name: params["name"],
      ttl_seconds: params["ttl_seconds"] || 1800,
      max_participants: params["max_participants"] || 16,
      voice_enabled: Map.get(params, "voice_enabled", true),
      chat_enabled: Map.get(params, "chat_enabled", true)
    }

    case Rooms.create_room(attrs) do
      {:ok, room} ->
        conn
        |> put_status(:created)
        |> json(%{
          success: true,
          room: room,
          message: "Ephemeral room provisioned. Expires in #{room.ttl_seconds} seconds."
        })

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{success: false, error: inspect(reason)})
    end
  end

  def lookup_code(conn, %{"code" => code}) do
    case Rooms.find_room_by_code(code) do
      {:ok, room_id} ->
        case Rooms.get_room_state(room_id) do
          {:ok, state} ->
            json(conn, %{success: true, room: state})

          _ ->
            conn
            |> put_status(:not_found)
            |> json(%{success: false, error: "Room has expired or been destroyed"})
        end

      {:error, :expired} ->
        conn
        |> put_status(:gone)
        |> json(%{success: false, error: "This ephemeral room code has expired"})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, error: "Invalid room code"})
    end
  end

  def show(conn, %{"id" => room_id}) do
    case Rooms.get_room_state(room_id) do
      {:ok, state} ->
        json(conn, %{success: true, room: state})

      _ ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, error: "Room not found or expired"})
    end
  end

  def delete(conn, %{"id" => room_id}) do
    Rooms.destroy_room(room_id)
    json(conn, %{success: true, message: "Ephemeral room destroyed"})
  end

  def webrtc_config(conn, _params) do
    # Standard STUN servers for WebRTC NAT traversal
    ice_servers = [
      %{"urls" => ["stun:stun.l.google.com:19302", "stun:stun1.l.google.com:19302"]},
      %{"urls" => ["stun:stun.cloudflare.com:3478"]}
    ]

    json(conn, %{
      iceServers: ice_servers,
      iceTransportPolicy: "all",
      bundlePolicy: "max-bundle",
      rtcpMuxPolicy: "require"
    })
  end
end
