defmodule CraftingSoftwareTest do
  use ExUnit.Case
  doctest CraftingSoftware

  test "greets the world" do
    assert CraftingSoftware.hello() == :world
  end
end
