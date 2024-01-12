defmodule CraftingSoftwareControllerTest do
  alias CraftingSoftware.Infrastructure.Controller
  use ExUnit.Case, async: true
  use Plug.Test

  @opts CraftingSoftware.Infrastructure.HttpEndpoint.init([])

  describe "Route and Controller test" do
    test "returns a 404 error on non existent page" do
      conn = conn(:get, "/non-existent")
      conn = CraftingSoftware.Infrastructure.HttpEndpoint.call(conn, @opts)

      assert conn.status == 404
      assert conn.resp_body == %{data: nil} |> Poison.encode!()
    end

    test "returns {:ok, tasks} when body_params is a map with a 'tasks' key" do
      body_params = %{"tasks" => ["task1", "task2"]}

      assert {:ok, tasks} = Controller.validate_tasks(body_params)
    end

    test "body_params is not a map with a 'tasks' key returns {:error, 'Data provided is not in appropriate format'}" do
      body_params = %{"other_key" => "value"}

      assert {:error, "Data provided is not in appropriate format"} =
               Controller.validate_tasks(body_params)
    end

    test "body_params is nil, returns {:error, 'Data provided is not in appropriate format'}" do
      body_params = nil

      assert {:error, "Data provided is not in appropriate format"} =
               Controller.validate_tasks(body_params)
    end

    test "body_params has tasks but its not a list, returns {:error, 'Data provided is not in appropriate format'}" do
      body_params = %{"tasks" => "not a list"}

      assert {:error, "Data provided is not in appropriate format"} =
               Controller.validate_tasks(body_params)
    end
  end
end
