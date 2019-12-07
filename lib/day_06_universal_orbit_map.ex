defmodule Adventofcode.Day06UniversalOrbitMap do
  use Adventofcode

  alias __MODULE__.{Parser, Orbits}

  def part_1(input) do
    input
    |> total_number_of_direct_and_indirect_orbits()
    |> Orbits.total()
  end

  def part_2(input) do
    input
    |> minimum_number_of_orbital_transfers_required()
    |> Orbits.distance("YOU", "SAN")
  end

  defmodule Orbits do
    @enforce_keys [:paths, :map]
    defstruct paths: [], map: %{}, direct: 0, indirect: 0, transfers: %{}

    def new({paths, map}) do
      %__MODULE__{paths: paths, map: map}
    end

    def count(orbits) do
      Enum.reduce(orbits.map, orbits, &count_direct/2)
    end

    defp count_direct({b, a}, orbits) do
      case get(orbits, b) do
        nil ->
          orbits

        c ->
          orbits
          |> increment(:direct)
          |> count_indirect(c)
      end
    end

    defp count_indirect(orbits, c) do
      case get(orbits, c) do
        nil ->
          orbits

        d ->
          orbits
          |> increment(:indirect)
          |> count_indirect(d)
      end
    end

    defp get(orbits, object) do
      orbits.map[object]
    end

    def increment(orbits, counter) do
      Map.update(orbits, counter, 1, &(&1 + 1))
    end

    def total(orbits) do
      orbits.direct + orbits.indirect
    end

    def follow(orbits) do
      transfers =
        orbits.paths
        |> Enum.map(&{Enum.at(&1, 1), follow_path(&1, orbits)})

      %{orbits | transfers: Enum.into(transfers, %{})}
    end

    def follow_path([c | _] = path, orbits) do
      case get(orbits, c) do
        nil -> path
        d -> follow_path([d | path], orbits)
      end
    end

    def distance(orbits, a, b) do
      a = Map.get(orbits.transfers, a)
      b = Map.get(orbits.transfers, b)
      do_distance(a, b)
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
      {paths, build_map(paths)}
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
  end

  def total_number_of_direct_and_indirect_orbits(input) do
    input
    |> Parser.parse()
    |> Orbits.new()
    |> Orbits.count()
  end

  def minimum_number_of_orbital_transfers_required(input) do
    input
    |> Parser.parse()
    |> Orbits.new()
    |> Orbits.follow()
  end
end
