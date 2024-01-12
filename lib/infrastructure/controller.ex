defmodule CraftingSoftware.Infrastructure.Controller do
  import Plug.Conn
  alias CraftingSoftware.Utils.Helpers

  @spec handle_process(Plug.Conn.t()) :: Plug.Conn.t()
  def handle_process(conn) do
    with {:ok, tasks} <- Helpers.validate_tasks(conn.body_params) do
      resp = tasks |> CraftingSoftware.Services.Task.sort_tasks()

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        200,
        %{"tasks" => resp}
        |> Poison.encode!()
      )
    else
      _ -> conn |> Helpers.return_invalid_response()
    end
  end

  @spec get_bash(Plug.Conn.t()) :: Plug.Conn.t()
  def get_bash(conn) do
    with {:ok, tasks} <- Helpers.validate_tasks(conn.body_params) do
      resp = tasks |> CraftingSoftware.Services.Task.get_bash_script()

      conn
      |> put_resp_content_type("text/*")
      |> send_resp(200, resp)
    else
      _ -> conn |> Helpers.return_invalid_response()
    end
  end
end
