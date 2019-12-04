defmodule Adventofcode.Day03CrossedWires do
  use Adventofcode

  alias __MODULE__.{CentralPort, Parser, Twister, Wire}

  def part_1(input) do
    closest_intersection_distance(input)
  end

  def part_2(input) do
    fewest_combined_steps_to_intersection(input)
  end

  def closest_intersection_distance(input) do
    input
    |> Parser.parse()
    |> Twister.twist()
    |> intersections()
    |> Map.keys()
    |> Enum.map(&manhattan_distance({0, 0}, &1))
    |> Enum.min()
  end

  def fewest_combined_steps_to_intersection(input) do
    input
    |> Parser.parse()
    |> Twister.twist()
    |> intersections()
    |> Map.values()
    |> Enum.min()
  end

  defp intersections(state) do
    wire1 = Enum.at(state.wires, 0)
    wire2 = Enum.at(state.wires, 1)

    positions1 = MapSet.new(Map.keys(wire1.visited))
    positions2 = MapSet.new(Map.keys(wire2.visited))

    MapSet.intersection(positions1, positions2)
    |> Enum.map(&{&1, wire1.visited[&1] + wire2.visited[&1]})
    |> Enum.into(%{})
  end

  def manhattan_distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  defmodule Wire do
    defstruct position: {0, 0}, visited: %{}, instructions: [], steps: 0
  end

  defmodule CentralPort do
    defstruct wires: []
  end

  defmodule Twister do
    def twist(state) do
      %{state | wires: twist_wires(state)}
    end

    defp twist_wires(state) do
      state.wires
      |> Enum.map(&twist_wire(state, &1))
    end

    defp twist_wire(state, %Wire{instructions: []}), do: state

    defp twist_wire(_state, wire) do
      wire.instructions
      |> Enum.flat_map(&split_instruction/1)
      |> Enum.reduce(wire, fn instruction, wire ->
        next_pos = move(wire.position, instruction)
        steps = wire.steps + 1

        %{
          wire
          | position: next_pos,
            visited: Map.put(wire.visited, next_pos, steps),
            steps: steps
        }
      end)
    end

    defp move({x, y}, "L"), do: {x - 1, y}
    defp move({x, y}, "R"), do: {x + 1, y}
    defp move({x, y}, "U"), do: {x, y - 1}
    defp move({x, y}, "D"), do: {x, y + 1}

    defp split_instruction(instruction) do
      direction = String.at(instruction, 0)
      distance = instruction |> String.slice(1..-1) |> String.to_integer()
      List.duplicate(direction, distance)
    end
  end

  defmodule Printer do
    @rows -8..1
    @cols -1..9
    def print(state) do
      IO.puts(build(state))
    end

    defp build(state) do
      @rows
      |> Enum.map_join("\n", &build_line(state, &1))
    end

    defp build_line(state, y) do
      @cols
      |> Enum.map_join(&get_value(state, {&1, y}))
    end

    defp get_value(_state, {0, 0}), do: "o"

    defp get_value(state, {x, y}) do
      if Enum.any?(state.wires, &has_visited(&1, {x, y})) do
        "#"
      else
        "."
      end
    end

    defp has_visited(wire, {x, y}) do
      wire.visited
      |> Map.keys()
      |> MapSet.new()
      |> MapSet.member?({x, y})
    end
  end

  defmodule Parser do
    alias Adventofcode.Day03CrossedWires.CentralPort

    def parse(input) do
      input
      |> String.split("\n")
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(&build_wires/1)
      |> build_central_port()
    end

    defp build_wires(instructions) do
      %Wire{instructions: instructions}
    end

    def build_central_port(wires) do
      %CentralPort{wires: wires}
    end
  end
end
