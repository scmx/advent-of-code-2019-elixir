defmodule Adventofcode.Day06UniversalOrbitMap do
  use Adventofcode

  alias __MODULE__.{Parser, Orbits}

  def part_1(input) do
    total_number_of_direct_and_indirect_orbits(input)
    |> Orbits.total()
  end

  defmodule Orbits do
    @enforce_keys [:map]
    defstruct map: %{}, direct: 0, indirect: 0

    def new(map) do
      %__MODULE__{map: map}
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
  end

  defmodule Parser do
    def parse(input) do
      input
      |> String.trim_trailing()
      |> String.split("\n")
      |> Enum.map(&parse_line/1)
      |> Enum.into(%{})
    end

    defp parse_line(line) do
      line
      |> String.split(")")
      |> Enum.reverse()
      |> List.to_tuple()
    end
  end

  def total_number_of_direct_and_indirect_orbits(input) do
    input
    |> Parser.parse()
    |> Orbits.new()
    |> Orbits.count()
  end
end
