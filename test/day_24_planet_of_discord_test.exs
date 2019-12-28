defmodule Adventofcode.Day24PlanetOfDiscordTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day24PlanetOfDiscord

  describe "part_1/1" do
    @input """
    ....#
    #..#.
    #..##
    ..#..
    #....
    """
    test "" do
      assert 2_129_920 = @input |> part_1()
    end

    test_with_puzzle_input do
      assert 11_042_850 = puzzle_input() |> part_1()
    end
  end
end
