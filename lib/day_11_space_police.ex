defmodule Adventofcode.Day11SpacePolice do
  use Adventofcode

  alias __MODULE__, as: Day
  alias __MODULE__.{Hull, Printer, Runner, Turner}
  alias Adventofcode.IntcodeComputer

  def part_1(input) do
    input
    |> IntcodeComputer.parse()
    |> IntcodeComputer.fallback_input(nil)
    |> Hull.new()
    |> Runner.run()
    |> Hull.painted_panels()
  end

  def part_2(input) do
    input
    |> IntcodeComputer.parse()
    |> IntcodeComputer.input(1)
    |> IntcodeComputer.fallback_input(nil)
    |> Hull.new()
    |> Runner.run()
    |> Printer.print()
  end

  defmodule Hull do
    alias Day.Painter

    @default_view {0..0, 0..0}

    defstruct panels: %{}, robot: {{0, 0}, "^"}, view: @default_view, program: nil

    def new(program) do
      %Hull{program: program}
    end

    def run(hull) do
      {outputs, program} = IntcodeComputer.pop_outputs(hull.program)

      hull
      |> Map.put(:program, program)
      |> run(Enum.chunk_every(outputs, 2))
    end

    def run(hull, []), do: hull

    def run(hull, [[paint_instruction, turn_instruction] | rest]) do
      hull
      |> Painter.paint_panel(paint_instruction)
      |> Turner.turn_and_move_robot(turn_instruction)
      |> run(rest)
    end

    def get_panel(%__MODULE__{panels: panels}, {x, y}) do
      Map.get(panels, {x, y}, 0)
    end

    def get_robot(%__MODULE__{robot: {{x, y}, dir}}, {x, y}), do: dir
    def get_robot(%__MODULE__{}, _), do: nil

    def camera(%{robot: {{x, y}, _}} = hull) do
      Map.get(hull.panels, {x, y}, 0)
    end

    def painted_panels(%__MODULE__{panels: panels}), do: Map.size(panels)
  end

  defmodule Runner do
    def run(%{program: %{status: :halted}} = hull), do: hull

    def run(hull) do
      hull
      |> Map.put(:program, run_program(hull))
      |> Hull.run()
      |> run()
    end

    defp run_program(hull) do
      hull.program
      |> IntcodeComputer.input(Hull.camera(hull))
      |> IntcodeComputer.run()
    end
  end

  defmodule Painter do
    def paint_panel(%{robot: {pos, _}} = hull, value) do
      panels = Map.put(hull.panels, pos, value)
      %{hull | panels: panels, view: update_view(hull.view, pos)}
    end

    defp update_view({x1..x2, y1..y2}, {x, y}) do
      {update_range(x1..x2, x), update_range(y1..y2, y)}
    end

    defp update_range(n1..n2, n) when n in n1..n2, do: n1..n2
    defp update_range(n1..n2, n) when n < n1, do: n..n2
    defp update_range(n1..n2, n) when n > n2, do: n1..n
  end

  defmodule Turner do
    def turn_and_move_robot(%{robot: robot} = hull, turn_instruction) do
      %{hull | robot: do_turn(robot, turn_instruction)}
    end

    defp do_turn({{x, y}, "^"}, 0), do: {{x - 1, y}, "<"}
    defp do_turn({{x, y}, "^"}, 1), do: {{x + 1, y}, ">"}
    defp do_turn({{x, y}, "v"}, 0), do: {{x + 1, y}, ">"}
    defp do_turn({{x, y}, "v"}, 1), do: {{x - 1, y}, "<"}
    defp do_turn({{x, y}, "<"}, 0), do: {{x, y + 1}, "v"}
    defp do_turn({{x, y}, "<"}, 1), do: {{x, y - 1}, "^"}
    defp do_turn({{x, y}, ">"}, 0), do: {{x, y - 1}, "^"}
    defp do_turn({{x, y}, ">"}, 1), do: {{x, y + 1}, "v"}
  end

  defmodule Printer do
    def print(hull) do
      IO.puts(s_print(hull))
      hull
    end

    def s_print(%{view: {_, y1..y2}} = hull) do
      y1..y2
      |> Enum.to_list()
      |> Enum.map_join("\n", &print_row(hull, &1))
    end

    defp print_row(%{view: {x1..x2, _}} = hull, y) do
      x1..x2
      |> Enum.to_list()
      |> Enum.map(&{&1, y})
      |> Enum.map_join(&do_print_row(hull, &1))
    end

    defp do_print_row(hull, pos) do
      hull
      |> print_pane(pos, Hull.get_panel(hull, pos), Hull.get_robot(hull, pos))
    end

    defp print_pane(_, {_, _}, 1, nil), do: "#"
    defp print_pane(_, {_, _}, 0, nil), do: "."
    defp print_pane(_, {_, _}, _, dir) when dir in ["^", "v", "<", ">"], do: dir
  end
end
