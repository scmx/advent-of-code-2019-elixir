defmodule Adventofcode.Day02ProgramAlarm do
  use Adventofcode

  import Adventofcode.IntcodeComputer

  def part_1(input, noun \\ 12, verb \\ 2) do
    input
    |> parse()
    |> List.update_at(1, fn _ -> noun end)
    |> List.update_at(2, fn _ -> verb end)
    |> run()
    |> hd()
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
