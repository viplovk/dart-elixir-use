defmodule HelloWorld do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: HelloWorld.Router, options: [port: 4000]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: HelloWorld.Supervisor)
  end
end
