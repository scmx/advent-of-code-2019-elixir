defmodule Adventofcode.Day07AmplificationCircuit do
  use Adventofcode

  alias Adventofcode.IntcodeComputer
  alias Adventofcode.IntcodeComputer.Program

  def part_1(input) do
    input
    |> IntcodeComputer.parse()
    |> max_thruster_signal()
  end

  def part_2(input) do
    input
    |> IntcodeComputer.parse()
    |> max_thruster_signal_feedback()
  end

  def max_thruster_signal(%Program{} = program) do
    0..4
    |> possible_amplifiers()
    |> Enum.map(&run_with_amplifiers(&1, program))
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&IntcodeComputer.output/1)
    |> Enum.max()
  end

  def max_thruster_signal_feedback(%Program{} = program) do
    5..9
    |> possible_amplifiers()
    |> Enum.map(&run_with_feedback(&1, Program.fallback_input(program, nil)))
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&IntcodeComputer.output/1)
    |> Enum.max()
  end

  def run_with_amplifiers(amplifiers, program) do
    amplifiers
    |> Enum.map(&Program.input(program, &1))
    |> Enum.map_reduce(0, &run/2)
  end

  def run_with_feedback(amplifiers, program) do
    amplifiers
    |> run_with_amplifiers(program)
    |> do_run_with_feedback()
  end

  def do_run_with_feedback({_, %Program{status: :halted}} = result), do: result

  def do_run_with_feedback({programs, previous}) do
    programs
    |> Enum.map_reduce(IntcodeComputer.output(previous), &run/2)
    |> do_run_with_feedback()
  end

  defp run(program, %Program{} = previous) do
    run(program, IntcodeComputer.output(previous))
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
