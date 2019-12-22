defmodule Adventofcode.Day21SpringdroidAdventureTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day21SpringdroidAdventure

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 19_352_638 = puzzle_input() |> part_1()
    end
  end
end
