defmodule WalkieTalkieWeb.Presence do
  @moduledoc """
  Provides real-time presence tracking for ephemeral room participants using CRDTs.
  Tracks:
  - Online status
  - Microphone state (muted / unmuted)
  - Speaking state (idle / transmitting)
  - Push-To-Talk active status
  - WebRTC connection quality (excellent / good / degraded / disconnected)
  """
  use Phoenix.Presence,
    otp_app: :walkie_talkie,
    pubsub_server: WalkieTalkie.PubSub

  @doc """
  Tracks participant presence in a specific room topic with their initial voice profile.
  """
  def track_user(socket, user_id, meta) do
    default_meta = %{
      user_id: user_id,
      username: meta[:username] || "Agent_#{String.slice(user_id, 0, 4)}",
      online: true,
      microphone_state: meta[:microphone_state] || "unmuted",
      speaking: false,
      ptt_active: false,
      connection_quality: meta[:connection_quality] || "excellent",
      joined_at: System.system_time(:millisecond)
    }

    track(socket, user_id, Map.merge(default_meta, Map.new(meta)))
  end

  @doc """
  Updates presence metadata when a user toggles PTT or updates connection state.
  """
  def update_voice_state(socket, user_id, voice_attrs) do
    update(socket, user_id, fn current_meta ->
      Map.merge(current_meta, voice_attrs)
    end)
  end

  @doc """
  Extracts and flattens presence list for client consumption.
  """
  def list_participants(topic) do
    list(topic)
    |> Enum.map(fn {user_id, %{metas: [primary | _]}} ->
      Map.put(primary, :user_id, user_id)
    end)
  end
end
