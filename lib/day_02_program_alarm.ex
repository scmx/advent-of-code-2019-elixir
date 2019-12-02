defmodule Adventofcode.Day02ProgramAlarm do
  use Adventofcode

  def part_1(input, noun \\ 12, verb \\ 2) do
    input
    |> parse()
    |> List.update_at(1, fn _ -> noun end)
    |> List.update_at(2, fn _ -> verb end)
    |> run()
    |> hd()
  end

  def run(program, position \\ 0)

  def run({:halt, program}, _position), do: program

  def run(program, position) do
    program
    |> Enum.drop(position)
    |> do_run(program)
    |> run(position + 4)
  end

  defp do_run([99 | _], program), do: {:halt, program}

  defp do_run([1, input1, input2, output | _], program) do
    result = Enum.at(program, input1) + Enum.at(program, input2)
    List.update_at(program, output, fn _ -> result end)
  end

  defp do_run([2, input1, input2, output | _], program) do
    result = Enum.at(program, input1) * Enum.at(program, input2)
    List.update_at(program, output, fn _ -> result end)
  end

  def parse(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
