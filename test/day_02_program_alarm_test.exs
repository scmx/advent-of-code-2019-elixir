defmodule Adventofcode.Day02ProgramAlarmTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day02ProgramAlarm

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
