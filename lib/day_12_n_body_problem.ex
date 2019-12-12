defmodule Adventofcode.Day12NBodyProblem do
  use Adventofcode

  @moduledoc """
  Each moon has a 3-dimensional position (x, y, and z)
  and a 3-dimensional velocity.

  The position of each moon is given in your scan;
  the x, y, and z velocity of each moon starts at 0.

  Simulate the motion of the moons in time steps.
  Within each time step, first update the velocity of every moon by applying gravity.
  Then, once all moons' velocities have been updated,
  update the position of every moon by applying velocity.
  Time progresses by one step once all of the positions are updated.

  ### GRAVITY
  To apply gravity, consider every pair of moons. On each axis (x, y, and z),
  the velocity of each moon changes by exactly +1 or -1 to pull the moons together.
  For example, if Ganymede has an x position of 3, and Callisto has a x position of 5,
  then Ganymede's x velocity changes by +1 (because 5 > 3)
  and Callisto's x velocity changes by -1 (because 3 < 5).
  However, if the positions on a given axis are the same,
  the velocity on that axis does not change for that pair of moons.

  Once all gravity has been applied, apply velocity: simply add the velocity of
  each moon to its own position. For example, if Europa has a position of x=1, y=2, z=3
  and a velocity of x=-2, y=0,z=3, then its new position would be x=-1, y=2, z=6.
  This process does not modify the velocity of any moon.
  """

  alias __MODULE__.{Parser, Planet, Position, Printer, Moon, Velocity}

  def part_1(input) do
    input
    |> Parser.parse()
    |> Planet.simulate_step(1000)
    |> Planet.total_energy()
  end

  def part_2(input) do
    input
    |> Parser.parse()
    |> Planet.simulate_step_repeat(1000)
    |> Planet.step()
  end

  defmodule Moon do
    defstruct pos: {0, 0, 0}, vel: {0, 0, 0}
  end

  defmodule Planet do
    defstruct step: 0, moons: []

    def step(%Planet{step: step}), do: step

    def simulate_step(%Planet{step: step} = planet, step), do: planet

    def simulate_step(%Planet{step: step} = planet, until_step) when step < until_step do
      planet
      |> Velocity.update_moons()
      |> Position.update_moons()
      |> Map.update!(:step, &(&1 + 1))
      |> simulate_step(until_step)
    end

    def simulate_step_repeat(planet), do: simulate_step_repeat(planet, MapSet.new())

    def simulate_step_repeat(planet, previous) do
      entry = Planet.serialize(planet)

      if MapSet.member?(previous, entry) && planet.step > 0 do
        planet
      else
        previous = MapSet.put(previous, entry)

        planet
        |> simulate_step(planet.step + 1)
        |> simulate_step_repeat(previous)
      end
    end

    def serialize(planet) do
      planet.moons
      |> Enum.map(&{&1.pos, &1.vel})
      |> List.to_tuple()
    end

    def total_energy(planet) do
      planet.moons
      |> Enum.map(&energy_moon/1)
      |> Enum.sum()
    end

    defp energy_moon(moon) do
      energy(moon.pos) * energy(moon.vel)
    end

    defp energy(values) do
      values
      |> Tuple.to_list()
      |> Enum.map(&abs/1)
      |> Enum.sum()
    end
  end

  defmodule Velocity do
    def update_moons(%Planet{moons: moons} = planet) do
      %{planet | moons: moons |> Enum.map(&update_moon(&1, moons -- [&1]))}
    end

    defp update_moon(moon, moons) do
      %{moon | vel: determine_velocity(moon, moons)}
    end

    defp determine_velocity(moon, moons) do
      [0, 1, 2]
      |> Enum.map(&update_velocity_dimension(moon, &1, moons))
      |> List.to_tuple()
    end

    defp update_velocity_dimension(%Moon{pos: pos, vel: vel}, index, moons) do
      other_vals = Enum.map(moons, &elem(&1.pos, index))

      update_velocity_value(elem(vel, index), elem(pos, index), other_vals)
    end

    defp update_velocity_value(vel, pos, other_vals) do
      Enum.reduce(other_vals, vel, fn
        other_pos, acc when other_pos > pos -> acc + 1
        other_pos, acc when other_pos < pos -> acc - 1
        _, acc -> acc
      end)
    end
  end

  defmodule Position do
    def update_moons(%Planet{moons: moons} = planet) do
      %{planet | moons: moons |> Enum.map(&update_moon/1)}
    end

    defp update_moon(moon) do
      %{moon | pos: next_pos(moon)}
    end

    defp next_pos(moon) do
      [0, 1, 2]
      |> Enum.map(&(elem(moon.pos, &1) + elem(moon.vel, &1)))
      |> List.to_tuple()
    end
  end

  defmodule Printer do
    def print(planet) do
      IO.puts("After #{planet.step} steps:\n#{print_moons(planet)}")
    end

    defp print_moons(%Planet{moons: moons}) do
      moons |> Enum.map_join("\n", &print_moon/1)
    end

    defp print_moon(%Moon{pos: {x, y, z}, vel: {xv, yv, zv}}) do
      :io_lib.format("pos=<x=~3b, y=~3b, z=~3b>, vel=<x=~3b, y=~3b, z=~3b>", [x, y, z, xv, yv, zv])
    end
  end

  defmodule Parser do
    def parse(input) do
      %Planet{moons: parse_moons(input)}
    end

    defp parse_moons(input) do
      ~r/-?\d+/
      |> Regex.scan(input)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(3)
      |> Enum.map(&List.to_tuple/1)
      |> Enum.map(&%Moon{pos: &1})
    end
  end
end
