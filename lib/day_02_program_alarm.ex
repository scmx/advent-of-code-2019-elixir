defmodule Adventofcode.Day02ProgramAlarm do
  use Adventofcode

  alias Adventofcode.IntcodeComputer
  alias Adventofcode.IntcodeComputer.Program

  def part_1(input, noun \\ 12, verb \\ 2) do
    input
    |> IntcodeComputer.parse()
    |> Program.input(1)
    |> Program.put(1, noun)
    |> Program.put(2, verb)
    |> IntcodeComputer.run()
    |> Program.get(0)
  end

  def part_2(input) do
    for(
      noun <- 0..99,
      verb <- 0..99,
      part_1(input, noun, verb) == 19_690_720,
      do: 100 * noun + verb
    )
    |> hd()
  end
end
