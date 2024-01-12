defmodule CraftingSoftware.Utils.Helpers do
  import Plug.Conn
  alias CraftingSoftware.Entities.Task

  @error_message "Data provided is not in appropriate format"

  @spec validate_tasks(any()) :: {:error, <<_::_*1>>} | {:ok, [...]}
  def validate_tasks(body_params) do
    with %{"tasks" => tasks} <- body_params,
         true <- is_list(tasks),
         true <- Enum.all?(tasks, &is_valid_shape?/1),
         true <- Enum.all?(tasks, &is_self_not_required?/1),
         true <- do_required_tasks_exist?(tasks),
         false <- are_tasks_cross_referencing?(tasks) do
      {:ok, tasks}
    else
      _ ->
        IO.warn(@error_message)
        {:error, @error_message}
    end
  end

  @spec return_invalid_response(Plug.Conn.t()) :: Plug.Conn.t()
  def return_invalid_response(conn) do
    conn
    |> put_resp_content_type("text/*")
    |> send_resp(422, "Bad request. " <> @error_message)
  end

  defp is_map_subset?(map, template) do
    template
    |> Map.delete(:__struct__)
    |> Map.keys()
    |> Enum.map(&Atom.to_string/1)
    |> Enum.all?(fn key ->
      Map.has_key?(map, key)
    end)
  end

  defp is_valid_shape?(item) when is_map(item) do
    is_map_subset?(item, %Task{})
  end

  defp is_valid_shape?(_), do: false

  defp do_required_tasks_exist?(tasks) when is_list(tasks) do
    names = tasks |> Enum.map(& &1["name"])

    tasks
    |> Enum.map(& &1["requires"])
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.filter(&(!is_nil(&1)))
    |> Enum.all?(&Enum.member?(names, &1))
  end

  defp do_required_tasks_exist?(_), do: false

  defp is_self_not_required?(task) do
    resp =
      case task["requires"] do
        nil -> false
        list -> list |> Enum.member?(task["name"])
      end

    !resp
  end

  defp are_tasks_cross_referencing?(tasks) do
    tasks
    |> Enum.map(fn t ->
      t
      |> Map.put(
        "required_by",
        tasks
        |> Enum.filter(fn rt -> rt["name"] != t["name"] end)
        |> Enum.filter(fn rf -> Enum.member?(rf["requires"] || [], t["name"]) end)
        |> Enum.map(& &1["name"])
      )
    end)
    |> Enum.map(fn m ->
      m
      |> Map.put(
        "intersect",
        Enum.any?(m["requires"] || [], fn rq ->
          Enum.member?(m["required_by"], rq)
        end)
      )
    end)
    |> Enum.any?(fn t -> t["intersect"] == true end)
  end
end
