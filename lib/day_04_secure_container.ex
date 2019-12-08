defmodule Adventofcode.Day04SecureContainer do
  use Adventofcode

  def part_1(input) do
    input
    |> parse_range()
    |> Enum.filter(&valid_part_1?/1)
    |> Enum.count()
  end

  def part_2(input) do
    input
    |> parse_range()
    |> Enum.filter(&valid_part_2?/1)
    |> Enum.count()
  end

  def valid_part_1?(input) do
    input
    |> prepare_password()
    |> (&(increases?(&1) && has_double?(&1))).()
  end

  def valid_part_2?(input) do
    input
    |> prepare_password()
    |> (&(increases?(&1) && has_separate_double?(&1))).()
  end

  defp parse_range(input) do
    input
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
    |> (fn [a, b] -> a..b end).()
    |> Enum.to_list()
    |> Enum.map(&to_string/1)
  end

  def prepare_password(password) do
    password
    |> to_string()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  defp increases?([_]), do: true
  defp increases?([x, y | _]) when x > y, do: false
  defp increases?([_, y | rest]), do: increases?([y | rest])

  defp has_double?([_]), do: false
  defp has_double?([x, x | _]), do: true
  defp has_double?([_, y | rest]), do: has_double?([y | rest])

  defp has_separate_double?([]), do: false
  defp has_separate_double?([_]), do: false
  defp has_separate_double?([x, x, x, x, x | _]), do: false
  defp has_separate_double?([x, x, x, x | rest]), do: has_separate_double?(rest)
  defp has_separate_double?([x, x, x | rest]), do: has_separate_double?(rest)
  defp has_separate_double?([x, x | _]), do: true
  defp has_separate_double?([_x, _y]), do: false
  defp has_separate_double?([_, y | rest]), do: has_separate_double?([y | rest])
end
