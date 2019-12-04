defmodule Adventofcode.Day04SecureContainer do
  use Adventofcode

  def part_1(input) do
    input
    |> parse_range()
    |> Enum.to_list()
    |> Enum.map(&to_string/1)
    |> Enum.filter(&valid_password?/1)
    |> Enum.count()
  end

  defp parse_range(input) do
    input
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
    |> (fn [a, b] -> a..b end).()
  end

  def valid_password?(password) do
    password
    |> to_string()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> meets_criteria?()
  end

  defp meets_criteria?(password) do
    has_double?(password) && increases?(password)
  end

  defp has_double?([x]), do: false
  defp has_double?([x, x | rest]), do: true
  defp has_double?([x, y | rest]), do: has_double?([y | rest])

  defp increases?([x]), do: true
  defp increases?([x, y | rest]) when x > y, do: false
  defp increases?([x, y | rest]), do: increases?([y | rest])
end
