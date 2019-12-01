defmodule Adventofcode.Day01TyrannyOfTheRocket do
  use Adventofcode

  def fuel_requirements_sum(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&fuel_requirements/1)
    |> Enum.sum()
  end

  def fuel_requirements_recursive_sum(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&fuel_requirements_recursive/1)
    |> Enum.sum()
  end

  def fuel_requirements(input) when is_number(input) do
    div(input, 3) - 2
  end

  def fuel_requirements_recursive(input) when is_number(input) do
    calculate_fuel(0, input)
  end

  defp calculate_fuel(acc, input) when input <= 0 do
    acc - input
  end

  defp calculate_fuel(acc, input) do
    result = div(input, 3) - 2
    calculate_fuel(acc + result, result)
  end
end
