defmodule Adventofcode.Day13CarePackage do
  use Adventofcode

  alias Adventofcode.IntcodeComputer

  alias __MODULE__.{ArcadeCabinet, Tiles}

  require Logger

  def part_1(input) do
    input
    |> IntcodeComputer.parse()
    |> ArcadeCabinet.new()
    |> ArcadeCabinet.run()
    |> ArcadeCabinet.count_block_tiles_on_screen()
  end

  defmodule ArcadeCabinet do
    @default_view {0..0, 0..0}

    defstruct tiles: %{}, view: @default_view, program: nil

    def new(program) do
      %ArcadeCabinet{program: program}
    end

    def run(%{program: %{status: :halted}} = arcade), do: arcade

    def run(arcade) do
      arcade
      |> Map.put(:program, run_program(arcade))
      |> draw()
      |> run()
    end

    defp run_program(arcade) do
      arcade.program
      |> IntcodeComputer.run()
    end

    def draw(arcade) do
      {outputs, program} = IntcodeComputer.pop_outputs(arcade.program)

      arcade
      |> Map.put(:program, program)
      |> draw(Enum.chunk_every(outputs, 3))
    end

    def draw(arcade, []), do: arcade

    def draw(arcade, [[x, y, tile_id] | rest]) do
      arcade
      |> Tiles.put({x, y}, parse_tile(tile_id))
      |> draw(rest)
    end

    defp parse_tile(0), do: :empty
    defp parse_tile(1), do: :wall
    defp parse_tile(2), do: :block
    defp parse_tile(3), do: :horizontal_paddle
    defp parse_tile(4), do: :ball

    def count_block_tiles_on_screen(arcade) do
      arcade.tiles
      |> Map.values()
      |> Enum.filter(&(&1 == :block))
      |> Enum.count()
    end
  end

  defmodule Tiles do
    def put(%{tiles: tiles} = arcade, pos, value) do
      tiles = Map.put(arcade.tiles, pos, value)
      %{arcade | tiles: tiles, view: update_view(arcade.view, pos)}
    end

    defp update_view({x1..x2, y1..y2}, {x, y}) do
      {update_range(x1..x2, x), update_range(y1..y2, y)}
    end

    defp update_range(n1..n2, n) when n in n1..n2, do: n1..n2
    defp update_range(n1..n2, n) when n < n1, do: n..n2
    defp update_range(n1..n2, n) when n > n2, do: n1..n
  end
end
