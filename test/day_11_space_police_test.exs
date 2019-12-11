defmodule Adventofcode.Day11SpacePoliceTest do
  use Adventofcode.FancyCase

  alias Adventofcode.Day11SpacePolice.{Hull, Printer}

  import ExUnit.CaptureIO
  import Adventofcode.Day11SpacePolice

  describe "paint/1" do
    @output0 """
    .....
    .....
    ..^..
    .....
    .....
    """

    @input1 [[1, 0]]
    @output1 """
    .....
    .....
    .<#..
    .....
    .....
    """
    test "paints according to input1" do
      hull = %Hull{view: {-2..2, -2..2}}
      assert @output0 == capture_io(fn -> Printer.print(hull) end)

      hull = Hull.run(hull, @input1)
      assert %Hull{robot: {{-1, 0}, "<"}, panels: %{{0, 0} => 1}} = hull

      assert @output1 == capture_io(fn -> Printer.print(hull) end)
    end

    @input2 [[0, 0]]
    @output2 """
    .....
    .....
    ..#..
    .v...
    .....
    """
    test "paints according to input2" do
      hull = %Hull{view: {-2..2, -2..2}}
      hull = Hull.run(hull, @input1)
      assert @output1 == capture_io(fn -> Printer.print(hull) end)

      hull = Hull.run(hull, @input2)
      assert %Hull{robot: {{-1, 1}, "v"}, panels: %{{0, 0} => 1, {-1, 0} => 0}} = hull

      assert @output2 == capture_io(fn -> Printer.print(hull) end)
    end

    @input3 [[1, 0], [1, 0]]
    @output3 """
    .....
    .....
    ..^..
    .##..
    .....
    """
    test "paints according to input3" do
      hull = %Hull{view: {-2..2, -2..2}}
      hull = Hull.run(hull, @input1 ++ @input2)
      assert @output2 == capture_io(fn -> Printer.print(hull) end)

      hull = Hull.run(hull, @input3)

      assert %Hull{
               robot: {{0, 0}, "^"},
               panels: %{{0, 0} => 1, {-1, 0} => 0, {-1, 1} => 1, {0, 1} => 1}
             } = hull

      assert @output3 == capture_io(fn -> Printer.print(hull) end)
    end

    @input4 [[0, 1], [1, 0], [1, 0]]
    @output4 """
    .....
    ..<#.
    ...#.
    .##..
    .....
    """
    test "paints according to input4" do
      hull = %Hull{view: {-2..2, -2..2}}
      hull = Hull.run(hull, @input1 ++ @input2 ++ @input3)
      assert @output3 == capture_io(fn -> Printer.print(hull) end)

      hull = Hull.run(hull, @input4)

      assert %Hull{
               robot: {{0, -1}, "<"},
               panels: %{
                 {0, 0} => 0,
                 {-1, 0} => 0,
                 {-1, 1} => 1,
                 {0, 1} => 1,
                 {1, 0} => 1,
                 {1, -1} => 1
               }
             } = hull

      assert @output4 == capture_io(fn -> Printer.print(hull) end)
      assert 6 = Hull.painted_panels(hull)
    end
  end

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 2511 = puzzle_input() |> part_1()
    end
  end

  describe "part_2/1" do
    @expected """
    .#..#...##.#..#...##.#..#..##..###..#..#...
    .#..#....#.#.#.....#.#.#..#..#.#..#.#..#...
    .####....#.##......#.##...#....#..#.####...
    .#..#....#.#.#.....#.#.#..#.##.###..#..#...
    .#..#.#..#.#.#..#..#.#.#..#..#.#....#..#.>.
    .#..#..##..#..#..##..#..#..###.#....#..#...
    """
    test_with_puzzle_input do
      assert @expected = capture_io(fn -> puzzle_input() |> part_2() end)
    end
  end
end
