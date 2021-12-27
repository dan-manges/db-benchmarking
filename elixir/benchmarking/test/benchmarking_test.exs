defmodule BenchmarkingTest do
  use ExUnit.Case
  doctest Benchmarking

  test "greets the world" do
    assert Benchmarking.hello() == :world
  end
end
