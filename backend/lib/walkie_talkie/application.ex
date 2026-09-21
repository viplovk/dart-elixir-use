defmodule WalkieTalkie.Application do
  @moduledoc """
  OTP Application root for WalkieTalkie.
  Supervises the Phoenix Endpoint, PubSub, Presence tracker,
  DynamicSupervisor for ephemeral Room GenServers, and the Room Registry.
  """
  use Application

  @impl true
  def start(_type, _args) do
    # Ephemeral in-memory storage for room metadata and fast indexing
    :ets.new(:ephemeral_rooms, [:named_table, :public, :set, read_concurrency: true])

    children = [
      WalkieTalkieWeb.Telemetry,
      {Phoenix.PubSub, name: WalkieTalkie.PubSub},
      WalkieTalkieWeb.Presence,
      # Registry to map room_id to room GenServer PID
      {Registry, keys: :unique, name: WalkieTalkie.RoomRegistry},
      # DynamicSupervisor that manages one GenServer process per active ephemeral room
      {DynamicSupervisor, strategy: :one_for_one, name: WalkieTalkie.RoomSupervisor},
      # Coordinator for room code lookups, expiration sweeps, and statistics
      WalkieTalkie.Rooms.Coordinator,
      WalkieTalkieWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: WalkieTalkie.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    WalkieTalkieWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
