import Config

config :walkie_talkie, WalkieTalkieWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "TestSecretKeyBaseForWalkieTalkieExUnitTesting1234567890abcdefghijkl",
  server: false

config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime
