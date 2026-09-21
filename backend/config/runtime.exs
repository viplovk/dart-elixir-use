import Config

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      "ProductionSecretKeyBaseWalkieTalkie998877665544332211AABBCCDDEEFFGG"

  port = String.to_integer(System.get_env("PORT") || "4000")

  config :walkie_talkie, WalkieTalkieWeb.Endpoint,
    http: [ip: {0, 0, 0, 0}, port: port],
    secret_key_base: secret_key_base
end
