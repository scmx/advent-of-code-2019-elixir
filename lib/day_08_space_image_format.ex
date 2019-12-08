defmodule Adventofcode.Day08SpaceImageFormat do
  use Adventofcode

  @black 0
  @white 1
  @transparent 2

  def part_1(input, {width, height}) do
    input
    |> least_corrupted_layer({width, height})
  end

  def part_2(input, {width, height}) do
    input
    |> render_pixels({width, height})
  end

  def least_corrupted_layer(input, {width, height}) do
    input
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(width * height)
    |> Enum.min_by(&count(&1, @black))
    |> sum_ones_and_twos()
  end

  def render_pixels(input, {width, height}) do
    input
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(width * height)
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&render_pixel/1)
    |> Enum.chunk_every(width)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.join("\n")
    |> do_render()
  end

  defp do_render(output) do
    IO.puts(output)
    output
  end

  defp render_pixel(pixel_layers) do
    pixel_layers
    |> Enum.map(&replace_black_with_space/1)
    |> Enum.find(&(&1 != @transparent))
  end

  defp replace_black_with_space(@black), do: " "
  defp replace_black_with_space(other), do: other

  defp count(layer, value) do
    layer
    |> Enum.count(&(&1 == value))
  end

  def sum_ones_and_twos(layer) do
    count(layer, @white) * count(layer, @transparent)
  end
end
