import Config

config :logger, level: :info

config :walkie_talkie, WalkieTalkieWeb.Endpoint,
  url: [host: "0.0.0.0", port: 4000],
  check_origin: false
