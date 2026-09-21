defmodule WalkieTalkieWeb.Router do
  @moduledoc """
  Phoenix Router providing REST endpoints for ephemeral room creation,
  code lookup, health checks, and ICE server configurations for WebRTC.
  """
  use WalkieTalkieWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WalkieTalkieWeb do
    pipe_through :api

    get "/health", RoomController, :health
    get "/rooms", RoomController, :index
    post "/rooms", RoomController, :create
    get "/rooms/code/:code", RoomController, :lookup_code
    get "/rooms/:id", RoomController, :show
    delete "/rooms/:id", RoomController, :delete
    get "/webrtc/config", RoomController, :webrtc_config
  end
end
