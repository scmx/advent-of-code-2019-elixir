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
    0..4
    |> possible_amplifiers()
    |> Enum.map(&run_with_amplifiers(&1, program))
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&IntcodeComputer.output/1)
    |> Enum.max()
  end

  def run_with_amplifiers(amplifiers, program) do
    amplifiers
    |> Enum.map(&Program.input(program, &1))
    |> Enum.map_reduce(0, &run/2)
  end

  defp run(program, %Program{output: output}) do
    run(program, output)
  end

  defp run(program, output) do
    program
    |> Program.input(output)
    |> Program.output(nil)
    |> IntcodeComputer.run()
    |> (&{&1, &1}).()
  end

  def possible_amplifiers(range) do
    for a <- range,
        b <- Enum.to_list(range) -- [a],
        c <- Enum.to_list(range) -- [a, b],
        d <- Enum.to_list(range) -- [a, b, c],
        e <- Enum.to_list(range) -- [a, b, c, d],
        do: [a, b, c, d, e]
  end
end
