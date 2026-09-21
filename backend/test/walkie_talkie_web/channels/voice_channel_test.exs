defmodule WalkieTalkieWeb.VoiceChannelTest do
  use ExUnit.Case, async: false
  import Phoenix.ChannelTest
  @endpoint WalkieTalkieWeb.Endpoint

  alias WalkieTalkie.Rooms
  alias WalkieTalkieWeb.UserSocket

  setup do
    {:ok, room} = Rooms.create_room(%{name: "Voice Test Room", ttl_seconds: 300})
    %{room: room}
  end

  test "WebRTC signaling messages are routed between peers", %{room: room} do
    {:ok, socket1} = connect(UserSocket, %{"user_id" => "peer_alice", "username" => "Alice"})
    {:ok, _, voice_socket1} = subscribe_and_join(socket1, "voice:#{room.room_id}", %{})

    # Send SDP Offer
    push(voice_socket1, "webrtc_offer", %{
      "to_peer_id" => "peer_bob",
      "sdp" => "v=0\r\no=alice 12345 2 IN IP4 127.0.0.1...",
      "type" => "offer"
    })

    assert_broadcast "webrtc_offer", %{
      from_peer_id: "peer_alice",
      to_peer_id: "peer_bob",
      type: "offer"
    }

    # Send ICE Candidate
    push(voice_socket1, "webrtc_ice_candidate", %{
      "to_peer_id" => "peer_bob",
      "candidate" => %{"candidate" => "candidate:1 1 UDP 2130706431...", "sdpMLineIndex" => 0}
    })

    assert_broadcast "webrtc_ice_candidate", %{
      from_peer_id: "peer_alice",
      to_peer_id: "peer_bob"
    }
  end

  test "push to talk start and stop broadcast speaking status", %{room: room} do
    {:ok, socket} = connect(UserSocket, %{"user_id" => "speaker_1", "username" => "Commander"})
    {:ok, _, voice_socket} = subscribe_and_join(socket, "voice:#{room.room_id}", %{})

    push(voice_socket, "push_to_talk_start", %{})
    assert_broadcast "speaking_start", %{user_id: "speaker_1"}

    push(voice_socket, "push_to_talk_stop", %{})
    assert_broadcast "speaking_stop", %{user_id: "speaker_1"}
  end
end
