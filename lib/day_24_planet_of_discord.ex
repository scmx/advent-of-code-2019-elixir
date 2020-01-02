defmodule Adventofcode.Day24PlanetOfDiscord do
  use Adventofcode

  alias __MODULE__.{
    BiodiversityRating,
    Bugs,
    Parser,
    Recursive,
    UntilRepeat
  }

  def part_1(input) do
    input
    |> Parser.parse()
    |> Bugs.new()
    |> UntilRepeat.run()
    |> BiodiversityRating.calculate()
  end

  def part_2(input, times \\ 200) do
    input
    |> Parser.parse()
    |> Bugs.new()
    |> Recursive.step(times)
    |> Bugs.count_bugs()
  end

  defmodule Direction do
    @enforce_keys [:x, :y]
    defstruct x: 0, y: 0

    def up, do: %Direction{x: 0, y: -1}
    def down, do: %Direction{x: 0, y: 1}
    def left, do: %Direction{x: 1, y: 0}
    def right, do: %Direction{x: -1, y: 0}
    def all, do: [left(), right(), up(), down()]
  end

  defmodule Position do
    @enforce_keys [:x, :y]
    defstruct x: 0, y: 0, z: 0

    def new(opts), do: struct!(Position, opts)
  end

  defmodule Bugs do
    def new(positions), do: MapSet.new(positions)

    def coordinates do
      for x <- 0..4, y <- 0..4, do: Position.new(x: x, y: y)
    end

    def coordinates(bugs) do
      layouts = bugs |> Enum.map(& &1.z)
      z1 = Enum.min(layouts) - 1
      z2 = Enum.max(layouts) + 1

      for x <- 0..4, y <- 0..4, z <- z1..z2, do: Position.new(x: x, y: y, z: z)
    end

    def count_bugs(bugs) do
      bugs
      |> Enum.reject(&(&1.x == 2 and &1.y == 2))
      |> length
    end

    def bug?(bugs, position), do: MapSet.member?(bugs, position)

    def should_be_bug?(nearby_count, true), do: nearby_count == 1

    def should_be_bug?(nearby_count, false), do: nearby_count in 1..2
  end

  defmodule UntilRepeat do
    def run(bugs, previous \\ MapSet.new()) do
      rating = BiodiversityRating.calculate(bugs)

      if MapSet.member?(previous, rating) do
        bugs
      else
        bugs
        |> step()
        |> run(MapSet.put(previous, rating))
      end
    end

    defp step(bugs) do
      Bugs.coordinates()
      |> Enum.filter(&should_be_bug?(bugs, &1))
      |> MapSet.new()
    end

    defp should_be_bug?(bugs, position) do
      position
      |> neighbours()
      |> Enum.count(&(&1 in bugs))
      |> Bugs.should_be_bug?(Bugs.bug?(bugs, position))
    end

    defp neighbours(%Position{} = position) do
      Direction.all()
      |> Enum.flat_map(&move(position, &1))
      |> Enum.filter(fn %{x: x, y: y} -> x in 0..4 and y in 0..4 end)
    end

    def move(%Position{x: x, y: y} = old, direction) do
      case %{old | x: x + direction.x, y: y + direction.y} do
        %{x: x, y: y} = position when x in 0..4 and y in 0..4 -> [position]
        _ -> []
      end
    end
  end

  defmodule Recursive do
    def step(bugs, times, done \\ 0)
    def step(bugs, times, times), do: bugs

    def step(bugs, times, done) do
      bugs
      |> Bugs.coordinates()
      |> Enum.filter(&should_be_bug?(bugs, &1))
      |> MapSet.new()
      |> step(times, done + 1)
    end

    defp should_be_bug?(bugs, position) do
      position
      |> neighbours()
      |> Enum.count(&(&1 in bugs))
      |> Bugs.should_be_bug?(Bugs.bug?(bugs, position))
    end

    defp neighbours(%Position{} = position) do
      Direction.all()
      |> Enum.flat_map(&move(position, &1))
      |> Enum.filter(fn %{x: x, y: y} -> x in 0..4 and y in 0..4 end)
    end

    defp move(%Position{} = old, direction) do
      position = %{old | x: old.x + direction.x, y: old.y + direction.y}

      cond do
        middle?(position) -> move_in(position, direction)
        outside?(position) -> move_out(position)
        true -> [position]
      end
    end

    defp middle?(%Position{x: x, y: y}), do: x == 2 && y == 2

    defp outside?(%Position{x: x, y: y}), do: x not in 0..4 or y not in 0..4

    defp move_in(pos, %{x: 1, y: 0}), do: do_move_in(%{pos | x: 0..0, y: 0..4})
    defp move_in(pos, %{x: -1, y: 0}), do: do_move_in(%{pos | x: 4..4, y: 0..4})
    defp move_in(pos, %{x: 0, y: 1}), do: do_move_in(%{pos | x: 0..4, y: 0..0})
    defp move_in(pos, %{x: 0, y: -1}), do: do_move_in(%{pos | x: 0..4, y: 4..4})

    defp do_move_in(%Position{x: x1..x2, y: y1..y2, z: z} = position) do
      for x <- x1..x2, y <- y1..y2, do: %{position | x: x, y: y, z: z + 1}
    end

    defp move_out(%{z: z, x: -1} = pos), do: [%{pos | x: 1, y: 2, z: z - 1}]
    defp move_out(%{z: z, x: 5} = pos), do: [%{pos | x: 3, y: 2, z: z - 1}]
    defp move_out(%{z: z, y: -1} = pos), do: [%{pos | x: 2, y: 1, z: z - 1}]
    defp move_out(%{z: z, y: 5} = pos), do: [%{pos | x: 2, y: 3, z: z - 1}]
  end

  defmodule BiodiversityRating do
    def calculate(bugs) do
      coordinates()
      |> Enum.map(&MapSet.member?(bugs, &1))
      |> Enum.map(&serialize/1)
      |> Enum.join()
      |> Integer.parse(2)
      |> elem(0)
    end

    defp serialize(true), do: 1
    defp serialize(false), do: 0

    defp coordinates do
      for y <- 4..0, x <- 4..0, do: Position.new(x: x, y: y)
    end
  end

  defmodule Parser do
    def parse(input) do
      input
      |> to_charlist()
      |> Enum.reject(&(&1 == ?\n))
      |> pattern_as_bug_positions
    end

    defp pattern_as_bug_positions(pattern) do
      width = pattern |> length |> :math.sqrt() |> trunc

      pattern
      |> Enum.with_index()
      |> Enum.filter(fn {char, _index} -> char == ?# end)
      |> Enum.map(fn {_char, index} -> index end)
      |> Enum.map(&as_position(&1, width))
    end

    defp as_position(index, width) do
      x = rem(index, width)
      y = div(index, width)
      Position.new(x: x, y: y, z: 0)
    end
  end
end
