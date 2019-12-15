defmodule Adventofcode.Day15OxygenSystem do
  use Adventofcode

  alias __MODULE__.{Direction, Droid, Maze, Position, Program, Runner, Tile}

  def part_1(input) do
    input
    |> Program.parse()
    |> Maze.new()
    |> Runner.find_oxygen_system()
    |> Map.get(:oxygen_system)
    |> Map.get(:steps)
  end

  defmodule Position do
    @enforce_keys [:x, :y]
    defstruct x: 0, y: 0

    def new(x, y), do: %Position{x: x, y: y}

    def move(position, direction) do
      %{position | x: position.x + direction.x, y: position.y + direction.y}
    end
  end

  defmodule Direction do
    @enforce_keys [:x, :y, :code]
    defstruct x: 0, y: 0, code: 0

    def north, do: %Direction{x: 0, y: -1, code: 1}
    def south, do: %Direction{x: 0, y: 1, code: 2}
    def west, do: %Direction{x: 1, y: 0, code: 3}
    def east, do: %Direction{x: -1, y: 0, code: 4}
    def all, do: [west(), east(), north(), south()]

    def code(%Direction{code: code}), do: code
  end

  defmodule Tile do
    @enforce_keys [:type, :code]
    defstruct type: :empty, code: 1

    def wall, do: %Tile{type: :wall, code: 0}
    def empty, do: %Tile{type: :empty, code: 1}
    def oxygen_system, do: %Tile{type: :oxygen_system, code: 2}
    def all, do: [wall(), empty(), oxygen_system()]

    def empty?(%Tile{type: :wall}), do: true
    def empty?(_tile), do: false

    def parse(code) do
      Enum.find(all(), &(&1.code == code)) || raise("Unknown tile with code #{code}")
    end
  end

  defmodule Program do
    alias Adventofcode.IntcodeComputer

    def parse(input) do
      input
      |> IntcodeComputer.parse()
      |> IntcodeComputer.fallback_input(nil)
    end

    def prepare_move(program, direction) do
      IntcodeComputer.input(program, Direction.code(direction))
    end

    def run(program) do
      program
      |> IntcodeComputer.run()
      |> IntcodeComputer.pop_outputs()
      |> tile_from_output
    end

    defp tile_from_output({[code], program}), do: {Tile.parse(code), program}
  end

  defmodule Droid do
    @enforce_keys [:program]
    defstruct program: nil, position: Position.new(0, 0), steps: 0, tile: nil

    def program(%Droid{program: program}), do: program
    def position(%Droid{position: position}), do: position
    def tile(%Droid{tile: tile}), do: tile

    def move(droid, direction) do
      program = Program.prepare_move(droid.program, direction)
      position = Position.move(droid.position, direction)

      %{droid | program: program, position: position, steps: droid.steps + 1}
    end

    def run_program(droid) do
      {tile, program} = Program.run(droid.program)
      %{droid | program: program, tile: tile}
    end

    def crashed_into_wall?(%Droid{tile: %Tile{type: :wall}}), do: true
    def crashed_into_wall?(_droid), do: false
  end

  defmodule Maze do
    @enforce_keys [:droids]
    defstruct tiles: %{Position.new(0, 0) => Tile.empty()},
              droids: [],
              oxygen_system: nil

    def new(program) do
      %Maze{droids: [%Droid{program: program}]}
    end

    def tile_visited?(%Maze{tiles: tiles}, position) do
      Map.has_key?(tiles, position)
    end

    def get_tile(%Maze{tiles: tiles}, position) do
      Map.get(tiles, position)
    end

    def get_droid(maze, position) do
      Enum.find(maze.droids, &(&1.position == position))
    end

    def get_droids(%Maze{droids: droids}), do: droids

    def set_droids(maze, droids), do: %{maze | droids: droids}

    def update_droids(maze, droids) do
      droids
      |> Enum.reduce(maze, &add_droid_tile(&2, &1))
      |> do_update_droids(droids)
    end

    defp do_update_droids(maze, droids) do
      %{maze | droids: Enum.reject(droids, &Droid.crashed_into_wall?/1)}
    end

    defp add_droid_tile(maze, %{tile: %{type: :oxygen_system}} = droid) do
      maze
      |> Map.update!(:oxygen_system, &(&1 || droid))
      |> do_add_droid_tile(droid)
    end

    defp add_droid_tile(maze, droid) do
      maze
      |> do_add_droid_tile(droid)
    end

    defp do_add_droid_tile(maze, droid) do
      tiles = Map.put(maze.tiles, droid.position, droid.tile)
      %{maze | tiles: tiles}
    end
  end

  defmodule Explorer do
    def explore(droids, maze) do
      droids = Enum.map(droids, &Droid.run_program/1)
      Maze.update_droids(maze, droids)
    end
  end

  defmodule Runner do
    def find_oxygen_system(maze), do: run(maze)

    def run(%{droids: []} = maze), do: maze

    def run(maze) do
      maze
      |> Maze.get_droids()
      |> Enum.flat_map(&unvisited_directions(maze, &1))
      |> Enum.uniq_by(&Droid.position/1)
      |> Explorer.explore(maze)
      |> run()
    end

    defp unvisited_directions(maze, droid) do
      Direction.all()
      |> Enum.map(&Droid.move(droid, &1))
      |> Enum.reject(&Maze.tile_visited?(maze, Droid.position(&1)))
    end
  end
end
