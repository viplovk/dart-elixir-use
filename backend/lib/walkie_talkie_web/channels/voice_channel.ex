defmodule WalkieTalkieWeb.VoiceChannel do
  @moduledoc """
  Phoenix Channel handling WebRTC voice signaling (SDP offer, answer, ICE candidates)
  and Push-To-Talk (PTT) speaking states.
  Integrates with Phoenix Presence to update speaking/mic states with sub-10ms latency.
  """
  use WalkieTalkieWeb, :channel
  require Logger

  alias WalkieTalkie.Rooms
  alias WalkieTalkieWeb.Presence

  @impl true
  def join("voice:" <> room_id, _payload, socket) do
    if Rooms.room_exists?(room_id) do
      socket = assign(socket, :room_id, room_id)
      send(self(), :broadcast_peer_join)
      {:ok, %{status: "voice_connected", room_id: room_id}, socket}
    else
      {:error, %{reason: "Room does not exist"}}
    end
  end

  @impl true
  def handle_info(:broadcast_peer_join, socket) do
    broadcast_from!(socket, "peer_joined", %{
      peer_id: socket.assigns.user_id,
      timestamp: System.system_time(:millisecond)
    })
    {:noreply, socket}
  end

  # WebRTC Signaling: SDP Offer
  @impl true
  def handle_in("webrtc_offer", %{"to_peer_id" => to_peer_id, "sdp" => sdp} = payload, socket) do
    broadcast_from!(socket, "webrtc_offer", %{
      from_peer_id: socket.assigns.user_id,
      to_peer_id: to_peer_id,
      sdp: sdp,
      type: payload["type"] || "offer"
    })
    {:reply, :ok, socket}
  end

  # WebRTC Signaling: SDP Answer
  @impl true
  def handle_in("webrtc_answer", %{"to_peer_id" => to_peer_id, "sdp" => sdp} = payload, socket) do
    broadcast_from!(socket, "webrtc_answer", %{
      from_peer_id: socket.assigns.user_id,
      to_peer_id: to_peer_id,
      sdp: sdp,
      type: payload["type"] || "answer"
    })
    {:reply, :ok, socket}
  end

  # WebRTC Signaling: ICE Candidate Exchange
  @impl true
  def handle_in("webrtc_ice_candidate", %{"to_peer_id" => to_peer_id, "candidate" => candidate}, socket) do
    broadcast_from!(socket, "webrtc_ice_candidate", %{
      from_peer_id: socket.assigns.user_id,
      to_peer_id: to_peer_id,
      candidate: candidate
    })
    {:reply, :ok, socket}
  end

  # Push-To-Talk Activated (Holding SPACE or Screen Button)
  @impl true
  def handle_in("push_to_talk_start", _payload, socket) do
    room_id = socket.assigns.room_id
    user_id = socket.assigns.user_id

    Rooms.start_ptt(room_id, user_id)

    # Fast Presence update for speaking status
    room_topic = "room:#{room_id}"
    Presence.update_voice_state(socket, user_id, %{
      speaking: true,
      ptt_active: true
    })

    broadcast!(socket, "speaking_start", %{
      user_id: user_id,
      timestamp: System.system_time(:millisecond)
    })

    {:reply, {:ok, %{status: "transmitting"}}, socket}
  end

  # Push-To-Talk Released
  @impl true
  def handle_in("push_to_talk_stop", _payload, socket) do
    room_id = socket.assigns.room_id
    user_id = socket.assigns.user_id

    Rooms.stop_ptt(room_id, user_id)

    room_topic = "room:#{room_id}"
    Presence.update_voice_state(socket, user_id, %{
      speaking: false,
      ptt_active: false
    })

    broadcast!(socket, "speaking_stop", %{
      user_id: user_id,
      timestamp: System.system_time(:millisecond)
    })

    {:reply, {:ok, %{status: "idle"}}, socket}
  end

  # Toggle Microphone Mute
  @impl true
  def handle_in("mute", _payload, socket) do
    user_id = socket.assigns.user_id
    Presence.update_voice_state(socket, user_id, %{microphone_state: "muted"})
    broadcast!(socket, "user_muted", %{user_id: user_id})
    {:reply, :ok, socket}
  end

  @impl true
  def handle_in("unmute", _payload, socket) do
    user_id = socket.assigns.user_id
    Presence.update_voice_state(socket, user_id, %{microphone_state: "unmuted"})
    broadcast!(socket, "user_unmuted", %{user_id: user_id})
    {:reply, :ok, socket}
  end

  # WebRTC Connection Quality Update
  @impl true
  def handle_in("connection_quality", %{"quality" => quality}, socket) do
    user_id = socket.assigns.user_id
    Presence.update_voice_state(socket, user_id, %{connection_quality: quality})
    {:reply, :ok, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    if Map.has_key?(socket.assigns, :room_id) do
      broadcast_from!(socket, "peer_left", %{
        peer_id: socket.assigns.user_id
      })
    end
    :ok
  end
end
