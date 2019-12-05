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

    def jump(program, position) do
      %{program | position: position}
    end

    def parse_instruction(program) do
      [opcode | args] = Enum.drop(program.addresses, program.position)
      modes = parse_modes(opcode)
      params = build_params(args, modes)

      opcode
      |> rem(100)
      |> prepare_instruction(params)
    end

    defp build_params(args, modes) do
      [args, modes]
      |> List.zip()
      |> Enum.map(fn {arg, mode} -> Parameter.new(arg, mode) end)
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

    defp prepare_instruction(1, [param1, param2, param3]) do
      {:add, [param1, param2, param3]}
    end

    defp prepare_instruction(2, [param1, param2, param3]) do
      {:multiply, [param1, param2, param3]}
    end

    defp prepare_instruction(3, [param1 | _]) do
      {:store, [param1]}
    end

    defp prepare_instruction(4, [param1 | _]) do
      {:output, [param1]}
    end

    defp prepare_instruction(99, _args) do
      {:halt, []}
    end

    def input(program, value) do
      %{program | input: value}
    end

    def output(program, value) do
      %{program | output: value}
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

      program
      |> Program.put(param3, result)
      |> Program.jump(program.position + 4)
    end

    def multiply(program, [param1, param2, param3]) do
      result = value(program, param1) * value(program, param2)

      program
      |> Program.put(param3, result)
      |> Program.jump(program.position + 4)
    end

    # Opcode 3 takes a single integer as input and saves it to the address given
    # by its only parameter. For example, the instruction 3,50 would take an
    # input value and store it at address 50.
    def store(program, [param1]) do
      program
      |> Program.put(param1, program.input)
      |> Program.jump(program.position + 2)
    end

    # Opcode 4 outputs the value of its only parameter. For example, the
    # instruction 4,50 would output the value at address 50.
    def output(program, [param1]) do
      program
      |> Program.output(value(program, param1))
      |> Program.jump(program.position + 2)
    end
  end

  def run(%Program{halt: true} = program), do: program

  def run(program) do
    {instruction, args} = Program.parse_instruction(program)

    apply(Computer, instruction, [program, args])
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
