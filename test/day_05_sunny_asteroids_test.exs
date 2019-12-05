defmodule Adventofcode.Day05SunnyAsteroidsTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day05SunnyAsteroids

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 15_426_686 = puzzle_input() |> part_1()
    end
  end
end
