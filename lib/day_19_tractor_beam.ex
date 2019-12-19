defmodule Adventofcode.Day19TractorBeam do
  use Adventofcode

  alias __MODULE__.{Grid, Position, Program}

  def part_1(input) do
    input
    |> part_1_grid()
    |> Grid.locations_affected_by_beam()
  end

  def part_1_grid(input) do
    input
    |> Program.parse()
    |> Grid.new(view: {0..49, 0..49})
    |> Grid.deploy_drones()
  end

  defmodule Position do
    @enforce_keys [:x, :y]
    defstruct x: 0, y: 0

    def new(x, y), do: %Position{x: x, y: y}

    def range({x_range, y_range}) do
      for y <- y_range, x <- x_range, do: new(x, y)
    end
  end

  defmodule Program do
    alias Adventofcode.IntcodeComputer

    def parse(input), do: IntcodeComputer.parse(input)

    def deploy_drone(program, %Position{x: x, y: y}) do
      program
      |> IntcodeComputer.inputs([x, y])
      |> IntcodeComputer.run()
      |> IntcodeComputer.output()
    end
  end

  defmodule Grid do
    @default_view {0..1, 0..1}

    @enforce_keys [:program]
    defstruct view: @default_view, program: nil, locations: %{}

    def new(program, options) do
      view = Keyword.get(options, :view, @default_view)
      %Grid{program: program, view: view}
    end

    def get_location(grid, position), do: Map.get(grid.locations, position)

    def deploy_drones(grid) do
      grid.view
      |> Position.range()
      |> Enum.reduce(grid, &do_deploy_drone(&2, &1))
    end

    defp do_deploy_drone(grid, position) do
      value = Program.deploy_drone(grid.program, position)
      %{grid | locations: Map.put(grid.locations, position, value)}
    end

    def locations_affected_by_beam(grid) do
      grid.locations
      |> Map.values()
      |> Enum.filter(&(&1 == 1))
      |> Enum.count()
    end
  end
end
