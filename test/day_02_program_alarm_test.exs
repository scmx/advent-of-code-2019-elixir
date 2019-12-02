defmodule Adventofcode.Day02ProgramAlarmTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day02ProgramAlarm

  describe "parse/1" do
    test "parses 1,0,0,0,99" do
      assert [1, 0, 0, 0, 99] = "1,0,0,0,99" |> parse()
    end
  end

  describe "run/1" do
    test "1,0,0,0,99 becomes 2,0,0,0,99" do
      assert [2, 0, 0, 0, 99] = [1, 0, 0, 0, 99] |> run()
    end

    test "2,3,0,3,99 becomes 2,3,0,6,99" do
      assert [2, 3, 0, 6, 99] = [2, 3, 0, 3, 99] |> run()
    end

    test "2,4,4,5,99,0 becomes 2,4,4,5,99,9801" do
      assert [2, 4, 4, 5, 99, 9801] = [2, 4, 4, 5, 99, 0] |> run()
    end

    test "1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99" do
      assert [30, 1, 1, 4, 2, 5, 6, 0, 99] = [1, 1, 1, 4, 99, 5, 6, 0, 99] |> run()
    end
  end

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 3_306_701 = puzzle_input() |> part_1()
    end
  end

  describe "part_2/1" do
    test_with_puzzle_input do
      assert 7621 = puzzle_input() |> part_2()
    end
  end
end
