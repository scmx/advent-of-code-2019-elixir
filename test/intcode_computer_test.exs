# test/intcode_computer_test.exs
defmodule Adventofcode.IntcodeComputerTest do
  use Adventofcode.FancyCase

  alias Adventofcode.IntcodeComputer.{Parameter, Program}

  import Adventofcode.IntcodeComputer

  describe "parse/1" do
    test "parses 1,0,0,0,99" do
      assert %Program{addresses: %{0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99}} =
               "1,0,0,0,99" |> parse()
    end
  end

  describe "run/1" do
    test "1,0,0,0,99 becomes 2,0,0,0,99" do
      assert %Program{addresses: %{0 => 2, 1 => 0, 2 => 0, 3 => 0, 4 => 99}} =
               [1, 0, 0, 0, 99] |> parse() |> run()
    end

    test "2,3,0,3,99 becomes 2,3,0,6,99" do
      assert %Program{addresses: %{0 => 2, 1 => 3, 2 => 0, 3 => 6, 4 => 99}} =
               [2, 3, 0, 3, 99] |> parse() |> run()
    end

    test "2,4,4,5,99,0 becomes 2,4,4,5,99,9801" do
      assert %Program{addresses: %{0 => 2, 1 => 4, 2 => 4, 3 => 5, 4 => 99, 5 => 9801}} =
               [2, 4, 4, 5, 99, 0] |> parse() |> run()
    end

    test "1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99" do
      assert %Program{
               addresses: %{
                 0 => 30,
                 1 => 1,
                 2 => 1,
                 3 => 4,
                 4 => 2,
                 5 => 5,
                 6 => 6,
                 7 => 0,
                 8 => 99
               }
             } = [1, 1, 1, 4, 99, 5, 6, 0, 99] |> parse() |> run()
    end

    @input ~i[109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
    test "takes no input and produces a copy of itself as output" do
      program = @input |> parse() |> run()
      assert @input == program |> outputs()
    end

    test "should output a 16-digit number" do
      assert 16 =
               "1102,34915192,34915192,7,4,7,99,0"
               |> parse()
               |> run()
               |> output()
               |> Integer.digits()
               |> length
    end

    test "should output the large number in the middle" do
      %Program{outputs: [output]} = "104,1125899906842624,99" |> parse() |> run()
      assert 1_125_899_906_842_624 = output
    end

    test "for example, if the relative base is 2000" do
      assert %Program{outputs: [12345], relative_base: 2019} =
               "109,19,204,-34,99"
               |> parse()
               |> Program.put(1985, 12345)
               |> Map.put(:relative_base, 2000)
               |> run()
    end

    test "109,1,203,-1,4,0,99" do
      assert %Program{outputs: [20 | _]} =
               "109,1,203,-1,4,0,99" |> parse() |> Program.input(20) |> run()
    end

    test "3,0,4,0,99" do
      assert %Program{outputs: [20 | _]} = "3,0,4,0,99" |> parse() |> Program.input(20) |> run()
    end
  end

  describe "Program.value/1" do
    test "a relative mode parameter refers to is itself plus the current relative base" do
      assert 123 =
               %Program{relative_base: 50, addresses: %{43 => 123}}
               |> Program.value(Parameter.new(-7, :relative))
    end
  end

  describe "Program.parse_instruction/1" do
    test "handles 203" do
      assert {:store, [%Parameter{value: 0, mode: :relative}]} =
               %Program{addresses: %{0 => 203, 1 => 0}} |> Program.parse_instruction()
    end
  end
end
