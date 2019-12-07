defmodule Adventofcode.Day07AmplificationCircuit do
  use Adventofcode

  alias Adventofcode.IntcodeComputer
  alias Adventofcode.IntcodeComputer.Program

  def part_1(input) do
    input
    |> IntcodeComputer.parse()
    |> max_thruster_signal()
  end

  def max_thruster_signal(%Program{} = program) do
    possible_amplifiers()
    |> Enum.map(&run_with_amplifiers(program, &1))
    |> Enum.max()
  end

  def run_with_amplifiers(program, amplifiers) do
    amplifiers
    |> Enum.reduce(0, &run(program, &1, &2))
  end

  defp run(program, amplifier, output) do
    program
    |> Program.input(output)
    |> Program.input(amplifier)
    |> IntcodeComputer.run()
    |> IntcodeComputer.output()
  end

  def possible_amplifiers do
    for a <- 0..4,
        b <- Enum.to_list(0..4) -- [a],
        c <- Enum.to_list(0..4) -- [a, b],
        d <- Enum.to_list(0..4) -- [a, b, c],
        e <- Enum.to_list(0..4) -- [a, b, c, d],
        do: [a, b, c, d, e]
  end
end
