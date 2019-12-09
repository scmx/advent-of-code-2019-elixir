defmodule Adventofcode.Day06UniversalOrbitMap do
  use Adventofcode

  alias __MODULE__.{Parser, Orbits}

  def part_1(input), do: new(input).total

  def part_2(input), do: Orbits.distance(new(input), "YOU", "SAN")

  defmodule Orbits do
    @enforce_keys [:transfers]
    defstruct transfers: %{}, direct: 0, indirect: 0, total: 0

    def new(transfers) do
      direct = transfers |> Map.keys() |> length

      indirect =
        transfers
        |> Map.values()
        |> Enum.map(&Enum.drop(&1, 2))
        |> Enum.map(&length/1)
        |> Enum.sum()

      total = direct + indirect
      %__MODULE__{transfers: transfers, direct: direct, indirect: indirect, total: total}
    end

    def distance(orbits, a, b) do
      do_distance(Map.get(orbits.transfers, a), Map.get(orbits.transfers, b))
    end

    defp do_distance([x | a], [x | b]), do: do_distance(a, b)

    defp do_distance(a, b) do
      length(a) + length(b) - 2
    end
  end

  defmodule Parser do
    def parse(input) do
      input
      |> String.trim_trailing()
      |> String.split("\n")
      |> Enum.map(&parse_line/1)
      |> build_paths_and_map()
    end

    defp build_paths_and_map(paths) do
      paths
      |> build_map()
      |> build_transfers(paths)
    end

    defp build_map(paths) do
      paths
      |> Enum.map(&Enum.reverse/1)
      |> Enum.map(&List.to_tuple/1)
      |> Enum.into(%{})
    end

    defp parse_line(line) do
      line
      |> String.split(")")
    end

    def build_transfers(map, paths) do
      paths
      |> Enum.map(&{Enum.at(&1, 1), follow_path(&1, map)})
      |> Enum.into(%{})
    end

    def follow_path([c | _] = path, map) do
      case Map.get(map, c) do
        nil -> path
        d -> follow_path([d | path], map)
      end
    end
  end

  def new(input) do
    input
    |> Parser.parse()
    |> Orbits.new()
  end
end
