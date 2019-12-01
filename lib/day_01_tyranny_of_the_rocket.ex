defmodule Adventofcode.Day01TyrannyOfTheRocket do
  use Adventofcode

  def fuel_requirements_sum(input) do
    input
    |> parse()
    |> Enum.map(&calculate_fuel/1)
    |> Enum.sum()
  end

  def fuel_requirements_recursive_sum(input) do
    input
    |> parse()
    |> Enum.map(&calculate_fuel/1)
    |> Enum.map(&break_down_fuel/1)
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def calculate_fuel(input) do
    div(input, 3) - 2
  end

  def break_down_fuel(input, acc \\ 0)

  def break_down_fuel(input, acc) when input <= 0, do: acc

  def break_down_fuel(input, acc) do
    input
    |> calculate_fuel()
    |> break_down_fuel(input + acc)
  end
end
