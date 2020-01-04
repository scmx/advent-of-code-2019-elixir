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

  describe "vaporization_order/1" do
    @input """
    .#....###24...#..
    ##...##.13#67..9#
    ##...#...5.8####.
    ..#.....X...###..
    ..#.#.....#....##
    """
    test "first nine asteroids to get vaporized, in order, would be" do
      v1 = [{8, 1}, {9, 0}, {9, 1}, {10, 0}, {9, 2}, {11, 1}, {12, 1}, {11, 2}, {15, 1}]
      v2 = [{12, 2}, {13, 2}, {14, 2}, {15, 2}, {12, 3}, {16, 4}, {15, 4}, {10, 4}, {4, 4}]
      v3 = [{2, 4}, {2, 3}, {0, 2}, {1, 2}, {0, 1}, {1, 1}, {5, 2}, {1, 0}, {5, 1}]
      v4 = [{6, 1}, {6, 0}, {7, 0}, {8, 0}, {10, 1}, {14, 0}, {16, 1}, {13, 3}, {14, 3}]

      assert v1 ++ v2 ++ v3 ++ v4 == @input |> vaporization_order
    end
  end

  describe "part_2/1" do
    test_with_puzzle_input do
      assert 1513 = puzzle_input() |> part_2()
    end
  end
end
