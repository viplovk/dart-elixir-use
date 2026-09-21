import Config

config :walkie_talkie, WalkieTalkieWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: String.to_integer(System.get_env("PORT") || "4000")],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "VwQZ36k6YmD6y615Rz1gYF53E2B6q8A1n8X9v3p2L4s6r1t8u5v2w9y3z6b8a1c4"

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
