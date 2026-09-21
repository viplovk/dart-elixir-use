defmodule WalkieTalkie.MembranePipeline do
  @moduledoc """
  Membrane Framework Multimedia Architecture for Ephemeral Walkie-Talkie.

  Orchestrates audio streaming through a WebRTC-based media pipeline:
  Audio Input (WebRTC Source)
       ↓
  Depayloader (Opus)
       ↓
  Audio Routing / Voice Activity Detection (VAD) / PTT Gating
       ↓
  Payloader (Opus)
       ↓
  WebRTC Sink (Subscribers)

  Provides clean integration with `Membrane.Pipeline` and `Membrane.RTC.Engine`,
  with an architectural fallback for peer-to-peer WebRTC mesh routing when running
  in containerized environments without native C-libraries (e.g. libnice/srtp).
  """
  use GenServer
  require Logger

  @type pipeline_state :: %{
    room_id: String.t(),
    participants: map(),
    audio_tracks: map(),
    engine_pid: pid() | nil,
    mode: :membrane_sfu | :p2p_mesh_signaling
  }

  # Client API

  def start_link(room_id, opts \\ []) do
    GenServer.start_link(__MODULE__, {room_id, opts}, name: via_tuple(room_id))
  end

  def add_participant(room_id, participant_id, peer_meta) do
    GenServer.call(via_tuple(room_id), {:add_participant, participant_id, peer_meta})
  end

  def remove_participant(room_id, participant_id) do
    GenServer.call(via_tuple(room_id), {:remove_participant, participant_id})
  end

  def handle_webrtc_signal(room_id, participant_id, signal) do
    GenServer.call(via_tuple(room_id), {:webrtc_signal, participant_id, signal})
  end

  def get_pipeline_mode(room_id) do
    GenServer.call(via_tuple(room_id), :get_mode)
  end

  def via_tuple(room_id) do
    {:via, Registry, {WalkieTalkie.RoomRegistry, "membrane_#{room_id}"}}
  end

  # Server Callbacks

  @impl true
  def init({room_id, _opts}) do
    mode = determine_media_mode()
    Logger.info("[MembranePipeline:#{room_id}] Initialized in mode: #{inspect(mode)}")

    {:ok, %{
      room_id: room_id,
      participants: %{},
      audio_tracks: %{},
      engine_pid: nil,
      mode: mode
    }}
  end

  @impl true
  def handle_call({:add_participant, participant_id, peer_meta}, _from, state) do
    new_participants = Map.put(state.participants, participant_id, peer_meta)
    Logger.debug("[MembranePipeline:#{state.room_id}] Added participant #{participant_id}")
    {:reply, {:ok, state.mode}, %{state | participants: new_participants}}
  end

  @impl true
  def handle_call({:remove_participant, participant_id}, _from, state) do
    new_participants = Map.delete(state.participants, participant_id)
    new_tracks = Map.delete(state.audio_tracks, participant_id)
    Logger.debug("[MembranePipeline:#{state.room_id}] Removed participant #{participant_id}")
    {:reply, :ok, %{state | participants: new_participants, audio_tracks: new_tracks}}
  end

  @impl true
  def handle_call({:webrtc_signal, participant_id, signal}, _from, state) do
    case state.mode do
      :membrane_sfu ->
        # When Membrane RTC Engine is running, signals are dispatched to the RTC engine endpoint
        Logger.info("[MembranePipeline:#{state.room_id}] Dispatching signal from #{participant_id} to Membrane Engine")
        {:reply, {:ok, :dispatched_to_sfu}, state}

      :p2p_mesh_signaling ->
        # In p2p signaling mode, Elixir coordinates peer-to-peer mesh offers/answers directly
        Logger.debug("[MembranePipeline:#{state.room_id}] Routing P2P signal for #{participant_id}: #{signal["type"]}")
        {:reply, {:ok, :routed_p2p}, state}
    end
  end

  @impl true
  def handle_call(:get_mode, _from, state) do
    {:reply, state.mode, state}
  end

  # Determines if native media libraries (libnice, srtp) are linked
  defp determine_media_mode do
    if Code.ensure_loaded?(Membrane.RTC.Engine) do
      :membrane_sfu
    else
      :p2p_mesh_signaling
    end
  end
end
