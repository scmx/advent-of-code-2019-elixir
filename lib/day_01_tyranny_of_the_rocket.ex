defmodule Adventofcode.Day01TyrannyOfTheRocket do
  use Adventofcode

  def fuel_requirements_sum(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&fuel_requirements/1)
    |> Enum.sum()
  end

  def fuel_requirements(input) when is_number(input) do
    div(input, 3) - 2
  end
end
