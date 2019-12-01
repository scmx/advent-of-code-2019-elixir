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

  describe "fuel_requirements_recursive/1" do
    # At first, a module of mass 1969 requires 654 fuel. Then, this fuel
    # requires 216 more fuel (654 / 3 - 2). 216 then requires 70 more fuel,
    # which requires 21 fuel, which requires 5 fuel, which requires no further
    # fuel. So, the total fuel required for a module of mass 1969 is 654 + 216 +
    # 70 + 21 + 5 = 966" do
    test "a module of mass 1969 requires 654 fuel. So, the total fuel required for a module of mass 1969 is 654 + 216 + 70 + 21 + 5 = 966" do
      assert 966 = 1969 |> fuel_requirements_recursive()
    end
  end

  describe "fuel_requirements_recursive_sum/1" do
    test_with_puzzle_input do
      assert 5_079_140 = puzzle_input() |> fuel_requirements_recursive_sum()
    end
  end
end
