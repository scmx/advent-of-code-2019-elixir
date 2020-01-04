defmodule Adventofcode.Day10MonitoringStation do
  use Adventofcode

  alias __MODULE__.{
    Asteroids,
    BestLocation,
    MonitoringStation,
    Parser,
    Printer,
    VaporizationOrder
  }

  def part_1(input) do
    input
    |> best_location()
    |> elem(1)
  end

  def part_2(input) do
    {x, y} = input |> vaporization_order() |> Enum.at(200 - 1)
    x * 100 + y
  end

  def best_location(input) do
    input
    |> Parser.parse()
    |> MonitoringStation.try_all()
    |> BestLocation.find()
    |> BestLocation.reachable_asteroids()
  end

  def vaporization_order(input) do
    input
    |> Parser.parse()
    |> MonitoringStation.try_all()
    |> BestLocation.find()
    |> VaporizationOrder.order()
  end

  defmodule Asteroids do
    @enforce_keys [:data, :max_x, :max_y]
    defstruct data: %{}, max_x: 0, max_y: 0

    def all(%Asteroids{data: data}), do: data

    def locations(%Asteroids{data: data}), do: Map.keys(data)

    def other_locations(asteroids, {x, y}) do
      locations(asteroids) -- [{x, y}]
    end

    def get(asteroids, {x, y}) do
      {{x, y}, Map.get(asteroids.data, {x, y})}
    end
  end

  defmodule BestLocation do
    def find(asteroids) do
      asteroids
      |> Asteroids.all()
      |> Enum.max_by(&length(elem(&1, 1)))
    end

    def reachable_asteroids({location, angles}), do: {location, length(angles)}
  end

  defmodule VaporizationOrder do
    def order({_location, angles}) do
      angles
      |> Enum.sort_by(fn {angle, _asteroids} -> angle end)
      |> Enum.map(fn {_angle, asteroids} -> asteroids end)
      |> expand_lists_to_same_length
      |> List.zip()
      |> Enum.flat_map(&Tuple.to_list/1)
      |> Enum.reject(&is_nil/1)
    end

    defp expand_lists_to_same_length(asteroids_in_angle_order) do
      max = asteroids_in_angle_order |> Enum.max_by(&length/1) |> length

      asteroids_in_angle_order
      |> Enum.map(&(&1 ++ List.duplicate(nil, max - length(&1))))
    end
  end

  defmodule MonitoringStation do
    def try_all(asteroids) do
      %{asteroids | data: do_find(asteroids)}
    end

    defp do_find(asteroids) do
      asteroids
      |> Asteroids.locations()
      |> Enum.map(&{&1, detect_asteroids(&1, asteroids)})
      |> Enum.into(%{})
    end

    defp detect_asteroids({x1, y1}, asteroids) do
      asteroids
      |> Asteroids.other_locations({x1, y1})
      |> Enum.group_by(&angle({{x1, y1}, &1}))
      |> Enum.map(&angle_asteroids_by_distance(&1, {x1, y1}))
    end

    defp angle_asteroids_by_distance({angle, asteroids}, {x1, y1}) do
      {angle, Enum.sort_by(asteroids, &manhattan_distance({x1, y1}, &1))}
    end

    def angle({{x1, y1}, {x2, y2}}) do
      dx = x2 - x1
      dy = y2 - y1

      cond do
        dx == 0 && dy < 0 -> 0
        dy == 0 && dx > 0 -> 90
        dx == 0 && dy > 0 -> 180
        dy == 0 && dx < 0 -> 270
        true -> do_angle({dx, dy}) + 90
      end
    end

    defp do_angle({dx, dy}) do
      radian = :math.atan(dy / dx)

      case radian * 180 / :math.pi() do
        degree when dx < 0 -> degree + 180
        degree -> degree
      end
    end

    defp manhattan_distance({x1, y1}, {x2, y2}) do
      abs(x2 - x1) + abs(y2 - y1)
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
    defp parse_location("#", {x, y}, acc), do: Map.put(acc, {x, y}, [])
    defp parse_location("X", {x, y}, acc), do: Map.put(acc, {x, y}, [])
    defp parse_location(_num, {x, y}, acc), do: parse_location("#", {x, y}, acc)
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
