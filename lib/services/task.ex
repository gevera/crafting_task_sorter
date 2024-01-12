defmodule CraftingSoftware.Services.Task do
  def sort_tasks(tasks) when is_list(tasks) do
    task_map =
      tasks
      |> Enum.reduce(%{}, fn task, acc ->
        acc
        |> Map.put(task["name"], task)
      end)

    sort_tasks_recursive(tasks, task_map, [])
    |> Enum.reverse()
    |> Enum.map(&Map.delete(&1, "requires"))
  end

  def sort_tasks([]), do: []
  def sort_tasks(_), do: []

  defp sort_tasks_recursive([], _, acc), do: acc

  defp sort_tasks_recursive([task | rest], task_map, acc) do
    deps = task |> Map.get("requires", [])
    deps_tasks = deps |> Enum.map(&Map.get(task_map, &1, nil))

    if deps_tasks |> Enum.all?(&(&1 in acc)) do
      updated_acc = [task | acc]
      sort_tasks_recursive(rest, task_map, updated_acc)
    else
      sort_tasks_recursive(rest ++ [task], task_map, acc)
    end
  end

  def get_bash_script(tasks) when is_list(tasks) do
    resp = sort_tasks(tasks) |> Enum.map(& &1["command"]) |> Enum.join("\n")
    "#" <> "!/usr/bin/env bash\n" <> resp
  end

  def get_bash_script([]), do: []
end
