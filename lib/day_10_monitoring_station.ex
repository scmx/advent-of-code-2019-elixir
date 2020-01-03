defmodule Adventofcode.Day10MonitoringStation do
  use Adventofcode

  alias __MODULE__.{Asteroids, Finder, Parser}

  def part_1(input) do
    input
    |> best_location()
    |> elem(1)
  end

  def best_location(input) do
    input
    |> all_locations()
    |> Enum.max_by(&elem(&1, 1))
  end

  defp all_locations(input) do
    input
    |> Parser.parse()
    |> Finder.find()
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

    defp distance({x1, y1}, {x2, y2}) do
      dx = x2 - x1
      dy = y2 - y1
      {dx, dy}
    end

    defp gcd_distance({dx, dy}) do
      gcd = Integer.gcd(dx, dy)
      {trunc(dx / gcd), trunc(dy / gcd)}
    end

    defp detect_asteroids({x1, y1}, asteroids) do
      asteroids
      |> Asteroids.other_locations({x1, y1})
      |> Enum.map(fn {x2, y2} -> {{x2, y2}, distance({x1, y1}, {x2, y2})} end)
      |> Enum.sort_by(fn {_, {dx, dy}} -> abs(dx) + abs(dy) end)
      |> Enum.uniq_by(fn {_, {dx, dy}} -> gcd_distance({dx, dy}) end)
    end
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

    defp build_data({line, y}, acc) do
      line
      |> Enum.reduce(acc, &parse_location(elem(&1, 0), {elem(&1, 1), y}, &2))
    end

    defp parse_location(".", {_, _}, acc), do: acc

    defp parse_location("#", {x, y}, acc) do
      Map.put(acc, {x, y}, [])
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
