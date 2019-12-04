defmodule Adventofcode.Day04SecureContainerTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day04SecureContainer

  describe "valid_password?" do
    test "111111 meets these criteria (double 11, never decreases)" do
      assert "111111" |> valid_password?()
    end

    test "223450 does not meet these criteria (decreasing pair of digits 50)" do
      refute "223450" |> valid_password?()
    end

    test "123789 does not meet these criteria (no double)" do
      refute "123789" |> valid_password?()
    end
  end

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 475 = puzzle_input() |> part_1()
    end
  end
end
