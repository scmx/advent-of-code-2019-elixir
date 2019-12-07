defmodule Adventofcode.Day07AmplificationCircuitTest do
  use Adventofcode.FancyCase

  alias Adventofcode.IntcodeComputer.Program

  import Adventofcode.Day07AmplificationCircuit

  describe "max_thruster_signal/1" do
    @input ~i[3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
    test "max thruster signal 43210 (from phase setting sequence 4,3,2,1,0)" do
      assert 43210 = @input |> Program.new() |> max_thruster_signal()
    end

    @input ~i[3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
    test "max thruster signal 54321 (from phase setting sequence 0,1,2,3,4)" do
      assert 54321 = @input |> Program.new() |> max_thruster_signal()
    end

    @input ~i[3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
    test "max thruster signal 65210 (from phase setting sequence 1,0,4,3,2)" do
      assert 65210 = @input |> Program.new() |> max_thruster_signal()
    end
  end

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 20413 = puzzle_input() |> part_1()
    end
  end
end
