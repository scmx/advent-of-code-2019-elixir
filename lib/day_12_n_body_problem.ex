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
  """

  alias __MODULE__.{Axis, Compare, Energy, Gravity, Moon, Parser, Point, Printer, Simulation}

  def part_1(input) do
    input
    |> Parser.parse()
    |> Simulation.run(1000)
    |> Simulation.total_energy()
  end

  def part_2(input) do
    input
    |> Parser.parse()
    |> Simulation.run_until_repeat()
    |> Simulation.get_repeats_every()
  end

  defmodule Simulation do
    defstruct step: 0, axes: [], repeats_every: 0

    def step(%Simulation{step: step}), do: step

    def get_repeats_every(%Simulation{repeats_every: step}), do: step

    def run(%Simulation{step: step} = simulation, step), do: simulation

    def run(%Simulation{step: step} = simulation, until_step) when step < until_step do
      simulation
      |> update_axes
      |> increment_step
      |> check_repeats_every()
      |> run(until_step)
    end

    def run_until_repeat(%Simulation{repeats_every: r} = simulation) when r > 0 do
      simulation
    end

    def run_until_repeat(%Simulation{step: step} = simulation) do
      simulation
      |> run(step + 1)
      |> update_repeats_every()
      |> run_until_repeat()
    end

    def total_energy(%Simulation{} = simulation) do
      simulation
      |> Moon.list_from_simulation()
      |> Energy.total()
    end

    defp update_axes(simulation) do
      %{simulation | axes: simulation.axes |> Enum.map(&Axis.update/1)}
    end

    defp check_repeats_every(%{step: step} = simulation) do
      axes = simulation.axes |> Enum.map(&Axis.check_repeats_every(&1, step))
      %{simulation | axes: axes}
    end

    defp increment_step(simulation) do
      %{simulation | step: simulation.step + 1}
    end

    defp update_repeats_every(simulation) do
      %{simulation | repeats_every: sum_repeats_every(simulation)}
    end

    defp sum_repeats_every(simulation) do
      simulation.axes
      |> Enum.map(& &1.repeats_every)
      |> Enum.reduce(&lcm/2)
    end

    # Least Common Multiple
    defp lcm(_, 0), do: 0
    defp lcm(a, b), do: div(a * b, Integer.gcd(a, b))
  end

  defmodule Axis do
    @enforce_keys [:current, :initial]
    defstruct current: [], initial: [], repeats_every: 0

    def update(axis) do
      axis
      |> update_current()
    end

    defp update_current(axis) do
      %{axis | current: next(axis)}
    end

    defp next(%Axis{current: current}) do
      current
      |> Enum.map(&Point.update_velocity(&1, current -- [&1]))
      |> Enum.map(&Point.update_position/1)
    end

    def check_repeats_every(%{repeats_every: 0} = axis, step) do
      %{axis | repeats_every: check_repeats(axis.current, axis.initial, step)}
    end

    def check_repeats_every(axis, _step), do: axis

    defp check_repeats(initial, initial, step), do: step
    defp check_repeats(_, _, _), do: 0
  end

  defmodule Point do
    @moduledoc """
    Once all gravity has been applied, apply velocity: simply add the velocity of
    each moon to its own position. For example, if Europa has a position of x=1, y=2, z=3
    and a velocity of x=-2, y=0,z=3, then its new position would be x=-1, y=2, z=6.
    This process does not modify the velocity of any moon.
    """

    @enforce_keys [:position]
    defstruct position: 0, velocity: 0

    def new(position, velocity) do
      %__MODULE__{position: position, velocity: velocity}
    end

    def update_velocity(point, other_points) do
      %{point | velocity: point.velocity + Gravity.apply(point, other_points)}
    end

    def update_position(point) do
      %{point | position: point.position + point.velocity}
    end
  end

  defmodule Gravity do
    @moduledoc """
    To apply gravity, consider every pair of moons. On each axis (x, y, and z),
    the velocity of each moon changes by exactly +1 or -1 to pull the moons
    together.

    For example, if Ganymede has an x position of 3,
    and Callisto has a x position of 5, then Ganymede's x velocity changes by +1
    (because 5 > 3) and Callisto's x velocity changes by -1 (because 3 < 5).
    However, if the positions on a given axis are the same, the velocity on that
    axis does not change for that pair of moons.
    """
    def apply(point, other_points) do
      other_points
      |> Enum.map(& &1.position)
      |> Enum.map(&Compare.compare(&1, point.position))
      |> Enum.sum()
    end
  end

  defmodule Compare do
    def compare(a, b) when is_number(a) and is_number(b) do
      do_compare(a, b)
    end

    defp do_compare(a, b) when a < b, do: -1
    defp do_compare(a, b) when a == b, do: 0
    defp do_compare(a, b) when a > b, do: 1
  end

  defmodule Energy do
    @moduledoc """
    It might help to calculate the total energy in the system. The total
    energy for a single moon is its potential energy multiplied by its kinetic
    energy. A moon's potential energy is the sum of the absolute values of its
    x, y, and z position coordinates. A moon's kinetic energy is the sum of the
    absolute values of its velocity coordinates.
    """

    def total(moons) do
      moons
      |> Enum.map(&energy_moon/1)
      |> Enum.sum()
    end

    defp energy_moon(moon) do
      energy(moon.position) * energy(moon.velocity)
    end

    defp energy(values) do
      values
      |> Tuple.to_list()
      |> Enum.map(&abs/1)
      |> Enum.sum()
    end
  end

  defmodule Moon do
    defstruct position: {0, 0, 0}, velocity: {0, 0, 0}

    def list_from_simulation(%Simulation{} = simulation) do
      simulation.axes
      |> Enum.map(& &1.current)
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&moon_data_from_points/1)
      |> Enum.map(fn [pos, vel] -> %Moon{position: pos, velocity: vel} end)
    end

    defp moon_data_from_points(points) do
      points
      |> Enum.map(&[&1.position, &1.velocity])
      |> List.zip()
    end
  end

  defmodule Printer do
    def print(%Simulation{} = simulation) do
      IO.puts("After #{simulation.step} steps:\n#{print_moons(simulation)}")
    end

    defp print_moons(simulation) do
      simulation
      |> Moon.list_from_simulation()
      |> Enum.map_join("\n", &print_moon/1)
    end

    defp print_moon(%Moon{position: {x, y, z}, velocity: {xv, yv, zv}}) do
      :io_lib.format("pos=<x=~3b, y=~3b, z=~3b>, vel=<x=~3b, y=~3b, z=~3b>", [x, y, z, xv, yv, zv])
    end
  end

  defmodule Parser do
    @moduledoc """
    # Parses input into three Axises, x, y, z that each contain the respectice
    # points.
    """

    def parse(input) do
      %Simulation{axes: parse_axes(input)}
    end

    defp parse_axes(input) do
      ~r/-?\d+/
      |> Regex.scan(input)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(&%Point{position: &1})
      |> Enum.chunk_every(3)
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&%Axis{current: &1, initial: &1})
    end
  end
end
