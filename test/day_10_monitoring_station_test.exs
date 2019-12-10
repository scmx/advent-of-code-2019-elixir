defmodule Adventofcode.Day10MonitoringStationTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day10MonitoringStation
  import Adventofcode.Day10MonitoringStation.Finder

  describe "best_location/1" do
    @input ~h"""
    .#..#
    .....
    #####
    ....#
    ...##
    """
    test "best location at 3,4 because it can detect 8 asteroids" do
      assert {{3, 4}, 8} = @input |> best_location()
    end
  end

  describe "blockers/1 finds locations where an asteroid could block sight between a and b" do
    test "three blockers directly between" do
      assert [{1, 1}, {2, 2}, {3, 3}] = blockers({0, 0}, {4, 4})
    end

    test "two blockers directly between" do
      assert [{1, 1}, {2, 2}] = blockers({0, 0}, {3, 3})
    end

    test "one blocker directly between" do
      assert [{1, 1}] = blockers({0, 0}, {2, 2})
    end

    test "one blocker diagonally between" do
      assert [{1, 2}] = blockers({0, 0}, {2, 4})
    end

    test "one blocker more diagonally between" do
      assert [{1, 3}] = blockers({0, 0}, {2, 6})
    end

    test "no blockers between" do
      assert [] = blockers({0, 0}, {2, 1})
    end
  end

  describe "part_1/1" do
    # test "" do
    #   assert 1337 = input |> part_1()
    # end

    test_with_puzzle_input do
      assert 1337 = puzzle_input() |> part_1()
    end
  end

  describe "manhattan_distance/2" do
    test "distance between 0,0 and 1,1 is 2" do
      assert 2 = manhattan_distance({0, 0}, {1, 1})
    end

    test "distance between 8,9 and 1,1 is 15 (=8-1+9-1)" do
      assert 15 = manhattan_distance({8, 9}, {1, 1})
    end

    test "distance between 1,1 and 8,9 is 15 (=8-1+9-1)" do
      assert 15 = manhattan_distance({8, 9}, {1, 1})
    end

    test "same line" do
      assert [{1, 0}, {2, 0}] = blockers({0, 0}, {3, 0})
    end

    test "same column" do
      assert [{0, 1}, {0, 02}] = blockers({0, 0}, {0, 3})
    end
  end
end
