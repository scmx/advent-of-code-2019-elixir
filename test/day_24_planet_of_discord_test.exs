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
    test "example a total biodiversity rating of 2129920" do
      assert 2_129_920 = @input |> part_1()
    end

    test_with_puzzle_input do
      assert 11_042_850 = puzzle_input() |> part_1()
    end
  end

  describe "part_2/1" do
    @input """
    ....#
    #..#.
    #..##
    ..#..
    #....
    """
    test "after 10 minutes, a total of 99 bugs are present" do
      assert 99 = @input |> part_2(10)
    end

    test_with_puzzle_input do
      assert 1967 = puzzle_input() |> part_2()
    end
  end
end
