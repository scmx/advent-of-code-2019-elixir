# lib/intcode_computer.ex
defmodule Adventofcode.IntcodeComputer do
  alias __MODULE__.{Computer, Parameter, Program}

  defmodule Parameter do
    @enforce_keys [:value, :mode]
    defstruct [:value, :mode]

    def new(value, 0), do: new(value, :positional)
    def new(value, 1), do: new(value, :immediate)
    def new(value, :positional = mode), do: do_new(value, mode)
    def new(value, :immediate = mode), do: do_new(value, mode)

    defp do_new(value, mode), do: %__MODULE__{value: value, mode: mode}
  end

  defmodule Program do
    @enforce_keys [:addresses, :input]
    defstruct addresses: [], input: 1, position: 0, halt: false, output: nil

    def new(addresses, input \\ 1) do
      %__MODULE__{addresses: addresses, input: input}
    end

    def get(program, position) do
      Enum.at(program.addresses, position)
    end

    def put(program, %Parameter{value: position}, value), do: put(program, position, value)

    def put(program, position, value) do
      %{program | addresses: List.update_at(program.addresses, position, fn _ -> value end)}
    end

    def jump(program, distance) do
      %{program | position: program.position + distance}
    end

    def parse_instruction(program) do
      [opcode, arg1, arg2, arg3 | _] = Enum.drop(program.addresses, program.position)
      [mode1, mode2, mode3] = parse_modes(opcode)

      params = [
        Parameter.new(arg1, mode1),
        Parameter.new(arg2, mode2),
        Parameter.new(arg3, mode3)
      ]

      parse_opcode(opcode, params)
    end

    defp parse_modes(opcode) do
      opcode
      |> div(100)
      |> to_string
      |> String.pad_leading(3, "0")
      |> String.reverse()
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end

    defp parse_opcode(opcode, [param1, param2, param3]) do
      case rem(opcode, 100) do
        1 -> {:add, [param1, param2, param3]}
        2 -> {:multiply, [param1, param2, param3]}
        99 -> {:halt, []}
      end
    end
  end

  defmodule Computer do
    alias Adventofcode.IntcodeComputer.{Parameter, Program}

    def value(program, %Parameter{value: position, mode: :positional}) do
      Program.get(program, position)
    end

    def value(_program, %Parameter{value: value, mode: :immediate}) do
      value
    end

    def halt(program, []), do: %{program | halt: true}

    def add(program, [param1, param2, param3]) do
      result = value(program, param1) + value(program, param2)
      Program.put(program, param3, result)
    end

    def multiply(program, [param1, param2, param3]) do
      result = value(program, param1) * value(program, param2)
      Program.put(program, param3, result)
    end
  end

  def run(%Program{halt: true} = program), do: program

  def run(program) do
    {instruction, args} = Program.parse_instruction(program)

    apply(Computer, instruction, [program, args])
    |> Program.jump(1 + length(args))
    |> run()
  end

  def parse(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Program.new()
  end

  def output(program) do
    program.output
  end
end
