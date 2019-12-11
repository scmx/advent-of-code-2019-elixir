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

    @input ~h"""
    ......#.#.
    #..#.#....
    ..#######.
    .#.#.###..
    .#..#.....
    ..#....#.#
    #..#....#.
    .##.#..###
    ##...#..#.
    .#....####
    """
    test "best location at 5,8 with 33 other asteroids detected" do
      assert {{5, 8}, 33} = @input |> best_location()
    end

    @input ~h"""
    #.#...#.#.
    .###....#.
    .#....#...
    ##.#.#.#.#
    ....#.#.#.
    .##..###.#
    ..#...##..
    ..##....##
    ......#...
    .####.###.
    """
    test "best is 1,2 with 35 other asteroids detected" do
      assert {{1, 2}, 35} = @input |> best_location()
    end

    @input ~h"""
    .#..#..###
    ####.###.#
    ....###.#.
    ..###.##.#
    ##.##.#.#.
    ....###..#
    ..#.#..#.#
    #..#.#.###
    .##...##.#
    .....#.#..
    """
    test "best is 6,3 with 41 other asteroids detected" do
      assert {{6, 3}, 41} = @input |> best_location()
    end

    @tag :skip
    @input ~h"""
    .#..##.###...#######
    ##.############..##.
    .#.######.########.#
    .###.#######.####.#.
    #####.##.#.##.###.##
    ..#####..#.#########
    ####################
    #.####....###.#.#.##
    ##.#################
    #####.##.###..####..
    ..######..##.#######
    ####.##.####...##..#
    .#####..#.######.###
    ##...#.##########...
    #.##########.#######
    .####.#.###.###.#.##
    ....##.##.###..#####
    .#.#.###########.###
    #.#.#.#####.####.###
    ###.##.####.##.#..##
    """
    test "best is 11,13 with 210 other asteroids detected" do
      assert {{11, 13}, 210} = @input |> best_location()
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

    # test_with_puzzle_input do
    #   assert 1337 = puzzle_input() |> part_1()
    # end
  end
end
