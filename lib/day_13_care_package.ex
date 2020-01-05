defmodule Adventofcode.Day13CarePackage do
  use Adventofcode

  alias Adventofcode.IntcodeComputer

  alias __MODULE__.{ArcadeCabinet, CountBlocks, PaddlesCheat, Printer}

  def part_1(input) do
    input
    |> IntcodeComputer.parse()
    |> ArcadeCabinet.new()
    |> ArcadeCabinet.run()
    |> CountBlocks.count_block_tiles_on_screen()
  end

  def part_2(input) do
    input
    |> PaddlesCheat.cheat()
    |> IntcodeComputer.parse()
    |> IntcodeComputer.put(0, 2)
    |> ArcadeCabinet.new()
    |> ArcadeCabinet.run()
    |> ArcadeCabinet.score()
  end

  defmodule PaddlesCheat do
    def cheat(input) do
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> paddles
    end

    @one 0 |> List.duplicate(41) |> List.replace_at(20, 3)
    @all 3 |> List.duplicate(41)

    defp paddles(opcodes, result \\ [])
    defp paddles([], result), do: Enum.reverse(result)
    defp paddles(@one ++ rest, result), do: paddles(rest, @all ++ result)
    defp paddles([val | rest], result), do: paddles(rest, [val | result])
  end

  defmodule ArcadeCabinet do
    defstruct tiles: %{}, view: {0..42, 0..22}, program: nil, score: 0

    def score(%ArcadeCabinet{score: score}), do: score

    def new(program), do: %ArcadeCabinet{program: program}

    def run(%{program: %{status: :halted}} = arcade), do: arcade
    def run(arcade), do: arcade |> step() |> run()

    def step(arcade) do
      {outputs, program} =
        arcade.program
        |> IntcodeComputer.run()
        |> IntcodeComputer.pop_outputs()

      arcade
      |> Map.put(:program, program)
      |> step(Enum.chunk_every(outputs, 3))
    end

    def step(arcade, []), do: arcade

    def step(arcade, [[-1, 0, score] | rest]) do
      %{arcade | score: score}
      |> step(rest)
    end

    def step(arcade, [[x, y, tile_id] | rest]) do
      %{arcade | tiles: Map.put(arcade.tiles, {x, y}, parse_tile(tile_id))}
      |> step(rest)
    end

    def get_tile(%__MODULE__{tiles: tiles}, {x, y}) do
      Map.get(tiles, {x, y}, 0)
    end

    defp parse_tile(0), do: :empty
    defp parse_tile(1), do: :wall
    defp parse_tile(2), do: :block
    defp parse_tile(3), do: :horizontal_paddle
    defp parse_tile(4), do: :ball
  end

  defmodule CountBlocks do
    def count_block_tiles_on_screen(arcade) do
      arcade.tiles
      |> Map.values()
      |> Enum.filter(&(&1 == :block))
      |> Enum.count()
    end
  end

  defmodule Printer do
    def s_print(%{view: {_, y1..y2}} = arcade) do
      y1..y2
      |> Enum.to_list()
      |> Enum.map_join("\n", &print_row(arcade, &1))
    end

    defp print_row(%{view: {x1..x2, _}} = arcade, y) do
      x1..x2
      |> Enum.to_list()
      |> Enum.map(&{&1, y})
      |> Enum.map_join(&do_print_row(arcade, &1))
    end

    defp do_print_row(arcade, pos) do
      print_tile(arcade, pos, ArcadeCabinet.get_tile(arcade, pos))
    end

    defp print_tile(_, {_, _}, :empty), do: "  "
    defp print_tile(_, {_, _}, :wall), do: "██"
    defp print_tile(_, {_, _}, :block), do: "▒▒"
    defp print_tile(_, {_, _}, :horizontal_paddle), do: "▁▁"
    defp print_tile(_, {_, _}, :ball), do: "🏐"
  end
end
