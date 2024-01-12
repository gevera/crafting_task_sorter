defmodule CraftingSoftwareServicesTaskTest do
  alias CraftingSoftware.Services.Task
  use ExUnit.Case

  describe "Sort tasks service test" do
    test "return an empty array when [] is passed to sort_tasks" do
      assert Task.sort_tasks([]) == []
    end

    test "return an empty array when nil is passed to sort_tasks" do
      assert Task.sort_tasks(nil) == []
    end

    test "return an empty array when true is passed to sort_tasks" do
      assert Task.sort_tasks(true) == []
    end

    test "return correct sorting in sort_tasks" do
      tasks = [
        %{"name" => "task1", "requires" => ["task2"], "command" => "command1"},
        %{"name" => "task2", "requires" => ["task3"], "command" => "command2"},
        %{"name" => "task3", "requires" => [], "command" => "command3"}
      ]

      expected_result = [
        %{"name" => "task3", "command" => "command3"},
        %{"name" => "task2", "command" => "command2"},
        %{"name" => "task1", "command" => "command1"}
      ]

      assert Task.sort_tasks(tasks) == expected_result
    end

    test "handle a single tasks" do
      tasks = [
        %{"name" => "task1", "command" => "command1"}
      ]

      expected_result = [%{"name" => "task1", "command" => "command1"}]

      assert Task.sort_tasks(tasks) == expected_result
    end


  end
end
