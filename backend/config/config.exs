import Config

config :walkie_talkie,
  namespace: WalkieTalkie,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :walkie_talkie, WalkieTalkieWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [formats: [json: WalkieTalkieWeb.ErrorJSON], layout: false],
  pubsub_server: WalkieTalkie.PubSub,
  live_view: [signing_salt: "WalkieTalkieSalt_x90234"]

# Configures Elixir logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Room default settings
config :walkie_talkie, WalkieTalkie.Rooms,
  default_ttl_seconds: 1800, # 30 minutes
  empty_room_grace_seconds: 120, # 2 minutes after last leaves
  max_participants_per_room: 16

import_config "#{config_env()}.exs"
