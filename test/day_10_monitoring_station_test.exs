defmodule Adventofcode.Day10MonitoringStationTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day10MonitoringStation
  import Adventofcode.Day10MonitoringStation.MonitoringStation

  describe "angle/2" do
    test "foo" do
      tests = %{
        0 => [{{2, 3}, {2, 0}}],
        45 => [{{0, 3}, {3, 0}}],
        90 => [{{0, 1}, {3, 1}}],
        135 => [{{0, 1}, {3, 4}}],
        180 => [{{2, 0}, {2, 3}}],
        225 => [{{3, 1}, {0, 4}}],
        270 => [{{3, 1}, {0, 1}}],
        315 => [{{3, 4}, {0, 1}}]
      }

      Enum.each(tests, fn {angle, cases} ->
        actual = cases |> Enum.map(&angle/1)
        expected = angle |> List.duplicate(length(actual))

        assert expected == actual
      end)
    end
  end

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

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 314 = puzzle_input() |> part_1()
    end
  end
end
