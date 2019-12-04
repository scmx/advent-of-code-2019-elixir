defmodule Adventofcode.Day04SecureContainerTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day04SecureContainer

  describe "valid_part_1?" do
    test "111111 meets these criteria (double 11, never decreases)" do
      assert "111111" |> valid_part_1?()
    end

    test "223450 does not meet these criteria (decreasing pair of digits 50)" do
      refute "223450" |> valid_part_1?()
    end

    test "123789 does not meet these criteria (no double)" do
      refute "123789" |> valid_part_1?()
    end
  end

  describe "valid_part_2?" do
    test "112233 meets these criteria" do
      assert "112233" |> valid_part_2?()
    end

    test "123444 no longer meets the criteria" do
      refute "123444" |> valid_part_2?()
    end

    test "111122 meets the criteria (even though 1 is repeated more than twice" do
      assert "111122" |> valid_part_2?()
    end
  end

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 475 = puzzle_input() |> part_1()
    end
  end

  describe "part_2/1" do
    test_with_puzzle_input do
      assert 297 = puzzle_input() |> part_2()
    end
  end
end
