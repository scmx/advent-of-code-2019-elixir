defmodule Adventofcode.Day10MonitoringStation do
  use Adventofcode

  alias __MODULE__.{Asteroids, Finder, Parser, Printer}

  def part_1(input) do
    input
    |> best_location()
  end

  def best_location(input) do
    input
    |> all_locations()
    |> Enum.max_by(&elem(&1, 1))
  end

  def all_locations(input) do
    input
    |> Parser.parse()
    |> Finder.find()
    |> Printer.print({11, 13})
    |> Map.get(:data)
    |> Enum.map(&{elem(&1, 0), length(Enum.uniq(elem(&1, 1)))})
  end

  defmodule Asteroids do
    @enforce_keys [:data, :max_x, :max_y]
    defstruct data: %{}, max_x: 0, max_y: 0

    def locations(asteroids) do
      Map.keys(asteroids.data)
    end

    def other_locations(asteroids, {x, y}) do
      locations(asteroids) -- [{x, y}]
    end

    def empty?(asteroids, {x, y}) do
      !Map.has_key?(asteroids.data, {x, y})
    end

    def get(asteroids, {x, y}) do
      {{x, y}, Map.get(asteroids.data, {x, y})}
    end
  end

  defmodule Finder do
    def find(asteroids) do
      %{asteroids | data: do_find(asteroids)}
    end

    defp do_find(asteroids) do
      asteroids
      |> Asteroids.locations()
      |> Enum.map(&{&1, detect_asteroids(&1, asteroids)})
      |> Enum.into(%{})
    end

    defp detect_asteroids({x, y}, asteroids) do
      asteroids
      |> Asteroids.other_locations({x, y})
      |> Enum.filter(&asteroid_between?({x, y}, &1, asteroids))
    end

    def asteroid_between?({x, y}, {ax, ay}, asteroids) do
      {x, y}
      |> blockers({ax, ay})
      |> Enum.all?(&Asteroids.empty?(asteroids, &1))

      # |> Enum.filter(&Map.has_key?(asteroids, &1))
    end

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

    defp whole?(val) when is_float(val), do: val == trunc(val) * 1.0
  end

  defmodule Parser do
    def parse(input) do
      input
      |> String.trim("\n")
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&Enum.with_index/1)
      |> Enum.with_index()
      |> build_asteroids()
    end

    defp build_asteroids(lines) do
      %Asteroids{
        max_x: length(elem(hd(lines), 0)) - 1,
        max_y: length(lines) - 1,
        data: lines |> Enum.reduce(%{}, &build_data/2)
      }
    end

    def build_data({line, y}, acc) do
      line
      |> Enum.reduce(acc, &parse_location(elem(&1, 0), {elem(&1, 1), y}, &2))
    end

    def parse_location(".", {_, _}, acc), do: acc

    def parse_location("#", {x, y}, acc) do
      Map.put(acc, {x, y}, nil)
    end
  end

  defmodule Printer do
    import IO.ANSI

    def print(asteroids, {x, y}) do
      IO.puts("\n" <> print_lines({x, y}, asteroids))
      asteroids
    end

    defp print_lines({x, y}, asteroids) do
      0..asteroids.max_y
      |> Enum.to_list()
      |> Enum.map_join("\n", &print_line(&1, {x, y}, asteroids))
    end

    defp print_line(y, pos, asteroids) do
      0..asteroids.max_x
      |> Enum.to_list()
      |> Enum.map_join(&print_pos({&1, y}, pos, asteroids))
    end

    defp print_pos(pos, pos2, asteroids) do
      do_print_pos(Asteroids.get(asteroids, pos), Asteroids.get(asteroids, pos2))
    end

    defp do_print_pos({{_, _}, nil}, {{_, _}, _}), do: "."
    defp do_print_pos({{_, _}, _}, {{_, _}, nil}), do: "#"

    defp do_print_pos({{x, y}, _}, {{x, y}, _}),
      do: format([blue(), "X", reset()])

    defp do_print_pos({pos, _}, {{_, _}, detected}) do
      if pos in detected, do: format([green(), "#", reset()]), else: format([red(), "#", reset()])
    end

    defp do_print_pos({{_, _}, _}, {{_, _}, _}), do: " "
  end
end
