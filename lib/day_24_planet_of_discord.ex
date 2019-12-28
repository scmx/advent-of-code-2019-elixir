defmodule Adventofcode.Day24PlanetOfDiscord do
  use Adventofcode

  alias __MODULE__.{Parser, State}

  def part_1(input) do
    input
    |> Parser.parse()
    |> State.new()
    |> State.run()
    |> State.serialize()
  end

  defmodule State do
    defstruct pattern: nil, width: 0, previous: MapSet.new()

    def new(pattern) do
      width = pattern |> length |> :math.sqrt() |> trunc
      %State{pattern: pattern, width: width}
    end

    def run(state) do
      serialized = serialize(state)

      case MapSet.member?(state.previous, serialized) do
        true ->
          state

        false ->
          %{state | previous: MapSet.put(state.previous, serialized)}
          |> step()
          |> run()
      end
    end

    def step(state) do
      %{state | pattern: do_step(state)}
    end

    defp do_step(state) do
      Enum.map(Enum.with_index(state.pattern), fn
        {true, index} ->
          quantity = Enum.count(directions(state, index), &(&1 == true))
          quantity == 1

        {false, index} ->
          quantity = Enum.count(directions(state, index), & &1)
          quantity in 1..2
      end)
    end

    defp directions(state, index) do
      x = rem(index, state.width)
      y = div(index, state.width)
      to_index = fn {x, y} -> x + y * state.width end

      [
        {x - 1, y},
        {x + 1, y},
        {x, y - 1},
        {x, y + 1}
      ]
      |> Enum.filter(fn {x, y} -> x in 0..4 && y in 0..4 end)
      |> Enum.map(to_index)
      |> Enum.map(&Enum.at(state.pattern, &1))
    end

    def serialize(%State{pattern: pattern}) do
      pattern
      |> Enum.map(&do_serialize/1)
      |> Enum.reverse()
      |> Enum.join()
      |> Integer.parse(2)
      |> elem(0)
    end

    defp do_serialize(true), do: 1
    defp do_serialize(false), do: 0
  end

  defmodule Parser do
    def parse(input) do
      input
      |> to_charlist()
      |> Enum.reject(&(&1 == ?\n))
      |> Enum.map(&as_boolean/1)
    end

    defp as_boolean(?#), do: true
    defp as_boolean(?.), do: false
  end
end
