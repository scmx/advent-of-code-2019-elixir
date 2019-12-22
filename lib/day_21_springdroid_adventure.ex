defmodule Adventofcode.Day21SpringdroidAdventure do
  use Adventofcode

  alias Adventofcode.IntcodeComputer

  @springscript """
  NOT A J
  NOT B T
  OR T J
  NOT C T
  OR T J
  AND D J
  WALK
  """
  def part_1(input), do: run(input, @springscript)

  defp run(input, springscript) do
    input
    |> IntcodeComputer.parse()
    |> IntcodeComputer.inputs(to_charlist(springscript))
    |> IntcodeComputer.fallback_input(nil)
    |> IntcodeComputer.run()
    |> IntcodeComputer.pop_outputs()
    |> handle_outputs
  end

  defp handle_outputs({outputs, program}) do
    do_handle_outputs(program, outputs, List.last(outputs))
  end

  defp do_handle_outputs(_, _, last) when last > 255, do: last

  defp do_handle_outputs(program, outputs, _last) do
    IO.puts(outputs)
    program
  end
end
