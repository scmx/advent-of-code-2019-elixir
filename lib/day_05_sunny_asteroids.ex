defmodule Adventofcode.Day05SunnyAsteroids do
  use Adventofcode

  alias Adventofcode.IntcodeComputer

  def part_1(input) do
    input
    |> IntcodeComputer.parse()
    |> IntcodeComputer.run()
    |> IntcodeComputer.output()
  end
end
