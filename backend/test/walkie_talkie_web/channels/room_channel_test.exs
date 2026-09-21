defmodule WalkieTalkieWeb.RoomChannelTest do
  use ExUnit.Case, async: false
  import Phoenix.ChannelTest
  @endpoint WalkieTalkieWeb.Endpoint

  alias WalkieTalkie.Rooms
  alias WalkieTalkieWeb.UserSocket

  setup do
    {:ok, room} = Rooms.create_room(%{name: "Channel Test Room", ttl_seconds: 300})
    %{room: room}
  end

  test "joins room channel and receives presence state and room state", %{room: room} do
    {:ok, socket} = connect(UserSocket, %{"user_id" => "test_usr_1", "username" => "AlphaOne"})
    {:ok, reply, channel_socket} = subscribe_and_join(socket, "room:#{room.room_id}", %{})

    assert reply.status == "connected"
    assert reply.room_id == room.room_id

    # Broadcast a message
    ref = push(channel_socket, "send_message", %{
      "encrypted_payload" => "U2FsdGVkX1+TestCipher",
      "nonce" => "123456"
    })

    assert_reply ref, :ok, %{status: "delivered"}
    assert_broadcast "new_message", %{sender_name: "AlphaOne"}
  end

  test "typing indicators are broadcast to peer participants", %{room: room} do
    {:ok, socket} = connect(UserSocket, %{"user_id" => "test_usr_2", "username" => "TypingTester"})
    {:ok, _, channel_socket} = subscribe_and_join(socket, "room:#{room.room_id}", %{})

    push(channel_socket, "typing_start", %{})
    assert_broadcast "user_typing_start", %{username: "TypingTester"}

    push(channel_socket, "typing_stop", %{})
    assert_broadcast "user_typing_stop", %{user_id: "test_usr_2"}
  end
end
