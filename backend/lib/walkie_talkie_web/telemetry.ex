defmodule WalkieTalkieWeb.Telemetry do
  @moduledoc """
  Telemetry metrics setup for Phoenix endpoint, channel event latencies, and VM metrics.
  """
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Phoenix Metrics
      summary("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),

      # Channel Metrics
      summary("phoenix.channel_handled_in.stop.duration",
        tags: [:event],
        unit: {:native, :millisecond}
      ),

      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :megabyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu")
    ]
  end

  defp periodic_measurements do
    [
      {__MODULE__, :measure_rooms, []}
    ]
  end

  def measure_rooms do
    count = :ets.info(:ephemeral_rooms, :size) || 0
    :telemetry.execute([:walkie_talkie, :rooms, :count], %{count: count})
  end
end
