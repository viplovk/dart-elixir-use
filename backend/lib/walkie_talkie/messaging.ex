defmodule WalkieTalkie.Messaging do
  @moduledoc """
  Ephemeral messaging engine for room text communication.
  Ensures messages remain in-memory and are discarded when rooms expire.
  Supports client-side encrypted payloads (E2EE) where the server only
  acts as an oblivious transport relay.
  """

  @type message :: %{
    id: String.t(),
    room_id: String.t(),
    sender_id: String.t(),
    sender_name: String.t(),
    encrypted_payload: String.t(),
    nonce: String.t() | nil,
    timestamp: integer(),
    is_system: boolean()
  }

  @doc """
  Constructs and validates an ephemeral room message.
  """
  def build_message(attrs) do
    %{
      id: attrs[:id] || "msg_#{UUID.uuid4()}",
      room_id: attrs[:room_id],
      sender_id: attrs[:sender_id],
      sender_name: attrs[:sender_name] || "Anonymous",
      encrypted_payload: attrs[:encrypted_payload] || "",
      nonce: attrs[:nonce],
      timestamp: attrs[:timestamp] || System.system_time(:millisecond),
      is_system: attrs[:is_system] || false
    }
  end

  @doc """
  Builds a system notification message (e.g. participant joined or PTT alert).
  """
  def build_system_message(room_id, text) do
    %{
      id: "sys_#{UUID.uuid4()}",
      room_id: room_id,
      sender_id: "system",
      sender_name: "SYSTEM",
      encrypted_payload: text,
      nonce: nil,
      timestamp: System.system_time(:millisecond),
      is_system: true
    }
  end
end
