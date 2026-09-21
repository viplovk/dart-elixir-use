defmodule WalkieTalkie.RoomsTest do
  use ExUnit.Case, async: false
  alias WalkieTalkie.Rooms

  setup do
    {:ok, room} = Rooms.create_room(%{name: "Alpha Test", ttl_seconds: 60, max_participants: 4})
    %{room: room}
  end

  test "creates ephemeral room with code and expiration", %{room: room} do
    assert room.room_id =~ "room_"
    assert room.room_code =~ ~r/^[A-Z]+-[A-Z0-9]+$/
    assert room.ttl_seconds == 60

    {:ok, state} = Rooms.get_room_state(room.room_id)
    assert state.name == "Alpha Test"
    assert state.participant_count == 0
    assert state.remaining_seconds > 0
  end

  test "look up room by room_code", %{room: room} do
    assert {:ok, room_id} = Rooms.find_room_by_code(room.room_code)
    assert room_id == room.room_id

    assert {:error, :not_found} = Rooms.find_room_by_code("NONEXISTENT-CODE")
  end

  test "joining and leaving room updates participant count", %{room: room} do
    user1 = %{id: "user_1", username: "Agent 1"}
    user2 = %{id: "user_2", username: "Agent 2"}

    assert {:ok, _} = Rooms.join_room(room.room_id, user1)
    assert {:ok, _} = Rooms.join_room(room.room_id, user2)

    {:ok, state} = Rooms.get_room_state(room.room_id)
    assert state.participant_count == 2

    assert :ok = Rooms.leave_room(room.room_id, "user_1")

    {:ok, state_after} = Rooms.get_room_state(room.room_id)
    assert state_after.participant_count == 1
  end

  test "enforces max participants limit", %{room: room} do
    for i <- 1..4 do
      assert {:ok, _} = Rooms.join_room(room.room_id, %{id: "user_#{i}", username: "User #{i}"})
    end

    assert {:error, :room_full} = Rooms.join_room(room.room_id, %{id: "user_5", username: "User 5"})
  end

  test "PTT start and stop manages active speaker state", %{room: room} do
    user = %{id: "user_ptt", username: "Talker"}
    Rooms.join_room(room.room_id, user)

    assert :ok = Rooms.start_ptt(room.room_id, "user_ptt")
    {:ok, state} = Rooms.get_room_state(room.room_id)
    assert state.voice_state.active_speaker == "user_ptt"
    assert "user_ptt" in state.voice_state.ptt_holders

    assert :ok = Rooms.stop_ptt(room.room_id, "user_ptt")
    {:ok, state_after} = Rooms.get_room_state(room.room_id)
    assert state_after.voice_state.active_speaker == nil
    refute "user_ptt" in state_after.voice_state.ptt_holders
  end

  test "destroying room removes it from registry and ETS", %{room: room} do
    assert Rooms.room_exists?(room.room_id)
    assert :ok = Rooms.destroy_room(room.room_id)

    # Allow time for GenServer termination
    Process.sleep(20)
    refute Rooms.room_exists?(room.room_id)
    assert {:error, :not_found} = Rooms.find_room_by_code(room.room_code)
  end
end
