defmodule Adventofcode.Day15OxygenSystemTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day15OxygenSystem

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 254 = puzzle_input() |> part_1()
    end
  end
end
