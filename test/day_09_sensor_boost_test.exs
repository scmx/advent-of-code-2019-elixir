defmodule Adventofcode.Day09SensorBoostTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day09SensorBoost

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 3_235_019_597 = puzzle_input() |> part_1()
    end
  end
end
