defmodule Adventofcode.Day10MonitoringStation do
  use Adventofcode

  alias __MODULE__.{Finder, Parser}

  def part_1(input) do
    input
    |> best_location()
  end

  def best_location(input) do
    input
    |> Parser.parse()
    |> Finder.find()
    |> (&{elem(&1, 0), length(elem(&1, 1))}).()
  end

  defmodule Finder do
    def find(asteroids) do
      asteroids
      |> Map.keys()
      |> Enum.map(&{&1, detect_asteroids(&1, asteroids)})
      |> Enum.max_by(&length(elem(&1, 1)))
    end

    defp detect_asteroids({x, y}, asteroids) do
      (Map.keys(asteroids) -- [{x, y}])
      |> Enum.filter(&asteroid_between?({x, y}, &1, asteroids))
    end

    def asteroid_between?({x, y}, {ax, ay}, asteroids) do
      {x, y}
      |> blockers({ax, ay})
      |> Enum.all?(&(!Map.has_key?(asteroids, &1)))

      # |> Enum.filter(&Map.has_key?(asteroids, &1))
    end

    # Avoid div 0 when both positions on same line (0 difference in x)
    def blockers({x, y1}, {x, y2}) do
      y1..y2
      |> Enum.to_list()
      |> Enum.slice(1..-2)
      |> Enum.map(&{x, &1})
    end

    def blockers({x1, y1}, {x2, y2}) do
      {m, b} = find_equation_of_line({x1, y1}, {x2, y2})

      x1..x2
      |> Enum.to_list()
      |> Enum.slice(1..-2)
      |> Enum.map(&{&1, m * &1 + b})
      |> Enum.filter(&whole?(elem(&1, 1)))
      |> Enum.map(&{elem(&1, 0), trunc(elem(&1, 1))})
    end

    def find_equation_of_line({x1, y1}, {x2, y2}) do
      m = (y2 - y1) / (x2 - x1)
      b = y1 - m * x1
      {m, b}
    end

    # defp between(x1, x2), do: manhattan_distance(x1, x2) - 1

    def manhattan_distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)
    def manhattan_distance(x1, x2), do: abs(x1 - x2)

    defp whole?(val) when is_float(val), do: val == trunc(val) * 1.0
  end

  defmodule Parser do
    def parse(input) do
      input
      |> String.trim_leading("\n")
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.reduce(%{}, &parse_line/2)
    end

    def parse_line({line, y}, acc) do
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, &parse_location(elem(&1, 0), {elem(&1, 1), y}, &2))
    end

    def parse_location(".", {_, _}, acc), do: acc

    def parse_location("#", {x, y}, acc) do
      Map.put(acc, {x, y}, nil)
    end
  end
end
