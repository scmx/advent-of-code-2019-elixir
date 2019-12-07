defmodule Adventofcode.Day05SunnyAsteroids do
  use Adventofcode

  alias Adventofcode.IntcodeComputer
  alias Adventofcode.IntcodeComputer.Program

  def part_1(input) do
    input
    |> IntcodeComputer.parse()
    |> Program.input(1)
    |> Program.input(0)
    |> IntcodeComputer.run()
    |> IntcodeComputer.output()
  end

  def part_2(input) do
    input
    |> IntcodeComputer.parse()
    |> Program.input(5)
    |> Program.input(0)
    |> IntcodeComputer.run()
    |> IntcodeComputer.output()
  end
end
