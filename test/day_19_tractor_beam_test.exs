defmodule Adventofcode.Day19TractorBeamTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day19TractorBeam

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 162 = puzzle_input() |> part_1()
    end
  end
end
