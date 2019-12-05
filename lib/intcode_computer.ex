# lib/intcode_computer.ex
defmodule Adventofcode.IntcodeComputer do
  def run(program, position \\ 0, input \\ 1)

  def run({:halt, program}, _position, _input), do: program

  def run(program, position, input) do
    {program, instruction_size} =
      program
      |> Enum.drop(position)
      |> do_run(program, input)

    run(program, position + instruction_size, input)
  end

  defp do_run([99 | _], program, _input), do: {{:halt, program}, 1}

  defp do_run([1, arg2, arg3, output | _], program, input) do
    result = Enum.at(program, arg2) + Enum.at(program, arg3)
    {List.update_at(program, output, fn _ -> result end), 4}
  end

  defp do_run([2, arg2, arg3, output | _], program, input) do
    result = Enum.at(program, arg2) * Enum.at(program, arg3)
    {List.update_at(program, output, fn _ -> result end), 4}
  end

  defp do_run([3, output | _], program, input) do
    {List.update_at(program, output, fn _ -> input end), 2}
  end

  defp do_run([4, arg2 | _], program, input) do
    IO.puts(Enum.at(program, arg2))
    {program, input}
  end

  def parse(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
