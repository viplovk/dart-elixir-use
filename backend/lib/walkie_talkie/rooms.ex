defmodule WalkieTalkie.Rooms do
  @moduledoc """
  The boundary context for Ephemeral Walkie-Talkie Rooms.
  Provides the primary Elixir API for creating, querying, and updating room states.
  """

  alias WalkieTalkie.Rooms.{Room, Coordinator}

  def create_room(attrs \\ %{}) do
    Coordinator.create_room(attrs)
  end

  def get_room_state(room_id) do
    if room_exists?(room_id) do
      Room.get_state(room_id)
    else
      {:error, :not_found}
    end
  end

  def find_room_by_code(code) do
    Coordinator.find_room_by_code(code)
  end

  def list_active_rooms do
    Coordinator.list_active_rooms()
  end

  def room_exists?(room_id) do
    case Registry.lookup(WalkieTalkie.RoomRegistry, room_id) do
      [{_pid, _value}] -> true
      [] -> false
    end
  end

  def join_room(room_id, user) do
    if room_exists?(room_id) do
      Room.join(room_id, user)
    else
      {:error, :not_found}
    end
  end

  def leave_room(room_id, user_id) do
    if room_exists?(room_id) do
      Room.leave(room_id, user_id)
    else
      :ok
    end
  end

  def post_message(room_id, message) do
    if room_exists?(room_id) do
      Room.post_message(room_id, message)
    else
      {:error, :not_found}
    end
  end

  def start_ptt(room_id, user_id) do
    if room_exists?(room_id) do
      Room.start_ptt(room_id, user_id)
    else
      {:error, :not_found}
    end
  end

  def stop_ptt(room_id, user_id) do
    if room_exists?(room_id) do
      Room.stop_ptt(room_id, user_id)
    else
      {:error, :not_found}
    end
  end

  def toggle_mute(room_id, user_id) do
    if room_exists?(room_id) do
      Room.toggle_mute(room_id, user_id)
    else
      {:error, :not_found}
    end
  end

  def destroy_room(room_id) do
    if room_exists?(room_id) do
      Room.destroy(room_id)
    else
      {:error, :not_found}
    end
  end
end
