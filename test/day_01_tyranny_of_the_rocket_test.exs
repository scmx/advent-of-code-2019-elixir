defmodule Adventofcode.Day01TyrannyOfTheRocketTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day01TyrannyOfTheRocket

  describe "fuel_requirements_sum/1" do
    test_with_puzzle_input do
      assert 3_388_015 = puzzle_input() |> fuel_requirements_sum()
    end
  end

  describe "fuel_requirements/1" do
    test "For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2" do
      assert 2 = 12 |> fuel_requirements()
    end

    test "For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2" do
      assert 2 = 14 |> fuel_requirements()
    end

    test "For a mass of 1969, the fuel required is 654" do
      assert 654 = 1969 |> fuel_requirements()
    end

    test "For a mass of 100756, the fuel required is 33583" do
      assert 33583 = 100_756 |> fuel_requirements()
    end
  end
end
