defmodule Adventofcode.Day09SensorBoost do
  use Adventofcode

  alias Adventofcode.IntcodeComputer
  alias Adventofcode.IntcodeComputer.Program

  def part_1(input) do
    input
    |> IntcodeComputer.parse()
    |> Program.input(1)
    |> IntcodeComputer.run()
    |> IntcodeComputer.output()
  end
end
