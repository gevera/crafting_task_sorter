defmodule CraftingSoftware.Infrastructure.HttpEndpoint do
  use Plug.Router
  alias CraftingSoftware.Infrastructure.Controller

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  post("/process", do: conn |> Controller.handle_process())

  post("/bash", do: conn |> Controller.get_bash())

  match _ do
    send_resp(conn, 404, %{data: nil} |> Poison.encode!())
  end
end
