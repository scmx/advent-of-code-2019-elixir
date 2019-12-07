defmodule Adventofcode.Day03CrossedWiresTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day03CrossedWires
  import ExUnit.CaptureIO

  alias Adventofcode.Day03CrossedWires.{CentralPort, Parser, Printer, Twister, Wire}

  describe "Parser.parse/1" do
    test "parses R8,U5,L5,D3" do
      assert %CentralPort{
               wires: [%Wire{instructions: ["R8", "U5", "L5", "D3"]}]
             } = "R8,U5,L5,D3" |> Parser.parse()
    end
  end

  describe "twist/1" do
    @output """
    ...........
    ...........
    ...........
    ....######.
    ....#....#.
    ....#....#.
    ....#....#.
    .........#.
    .o########.
    ...........
    """
    test "R8,U5,L5,D3 twists according to" do
      state = "R8,U5,L5,D3" |> Parser.parse() |> Twister.twist()
      fun = fn -> Printer.print(state) end

      result = capture_io(fun)

      assert result === @output
    end
  end

  describe "closest_intersection_distance/1" do
    test "R8,U5,L5,D3\nU7,R6,D4,L4" do
      assert 6 = "R8,U5,L5,D3\nU7,R6,D4,L4" |> closest_intersection_distance()
    end

    test "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83" do
      assert 159 =
               "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
               |> closest_intersection_distance()
    end

    test "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7" do
      assert 135 =
               "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
               |> closest_intersection_distance()
    end
  end

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 303 = puzzle_input() |> part_1()
    end
  end

  describe "part_2/1" do
    test_with_puzzle_input do
      assert 11222 = puzzle_input() |> part_2()
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
  end
end
