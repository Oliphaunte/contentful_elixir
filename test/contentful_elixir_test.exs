defmodule ContentfulElixirTest do
  use ExUnit.Case
  doctest ContentfulElixir

  test "greets the world" do
    assert ContentfulElixir.hello() == :world
  end
end
