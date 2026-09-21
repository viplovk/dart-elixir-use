defmodule WalkieTalkie.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :walkie_talkie,
      version: @version,
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {WalkieTalkie.Application, []},
      extra_applications: [:logger, :runtime_tools, :crypto]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.7.14"},
      {:phoenix_pubsub, "~> 2.1"},
      {:plug_cowboy, "~> 2.7"},
      {:jason, "~> 1.4"},
      {:cors_plug, "~> 3.0"},
      {:uuid, "~> 1.1"},
      # Membrane Framework Multimedia Pipeline for WebRTC SFU / Media routing
      {:membrane_core, "~> 1.0"},
      {:membrane_webrtc_plugin, "~> 0.18.0", optional: true},
      {:membrane_rtc_engine, "~> 0.9.0", optional: true},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.1"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get"]
    ]
  end
end
