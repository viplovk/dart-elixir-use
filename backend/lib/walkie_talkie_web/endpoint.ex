defmodule WalkieTalkieWeb.Endpoint do
  @moduledoc """
  Phoenix Endpoint for WalkieTalkie.
  Mounts the UserSocket for real-time WebSocket channels on /socket
  and provides CORS, JSON parsers, and health checks.
  """
  use Phoenix.Endpoint, otp_app: :walkie_talkie

  # WebSocket endpoint for Phoenix Channels
  socket "/socket", WalkieTalkieWeb.UserSocket,
    websocket: [
      timeout: 45_000,
      connect_info: [:peer_data, :x_headers, :uri]
    ],
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  plug Plug.Static,
    at: "/",
    from: :walkie_talkie,
    gzip: false,
    only: WalkieTalkieWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug CORSPlug, origin: ["*"]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug WalkieTalkieWeb.Router

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)
end
