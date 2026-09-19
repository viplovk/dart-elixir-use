defmodule HelloWorld.Router do
  use Plug.Router

  plug Plug.Logger
  plug Plug.Static,
    at: "/",
    from: "../dart_frontend/web",
    gzip: false

  plug :match
  plug :dispatch

  get "/api/hello" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, ~s({"message":"Hello World","runtime":"Elixir"}))
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
