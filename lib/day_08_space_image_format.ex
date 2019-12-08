defmodule Adventofcode.Day08SpaceImageFormat do
  use Adventofcode

  @black 0
  @white 1
  @transparent 2

  def part_1(input, {width, height}) do
    input
    |> least_corrupted_layer({width, height})
  end

  def least_corrupted_layer(input, {width, height}) do
    input
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(width * height)
    |> Enum.min_by(&count(&1, @black))
    |> sum_ones_and_twos()
  end

  defp count(layer, value) do
    layer
    |> Enum.count(&(&1 == value))
  end

  def sum_ones_and_twos(layer) do
    count(layer, @white) * count(layer, @transparent)
  end
end
