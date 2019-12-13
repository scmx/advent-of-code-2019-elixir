defmodule Adventofcode.Day12NBodyProblemTest do
  use Adventofcode.FancyCase

  alias Adventofcode.Day12NBodyProblem.{Parser, Simulation, Printer}

  import Adventofcode.Day12NBodyProblem
  import ExUnit.CaptureIO

  describe "suppose your scan reveals the following positions" do
    @input """
    <x=-1, y=0, z=2>
    <x=2, y=-10, z=-7>
    <x=4, y=-8, z=8>
    <x=3, y=5, z=-1>
    """

    @expected """
    After 0 steps:
    pos=<x= -1, y=  0, z=  2>, vel=<x=  0, y=  0, z=  0>
    pos=<x=  2, y=-10, z= -7>, vel=<x=  0, y=  0, z=  0>
    pos=<x=  4, y= -8, z=  8>, vel=<x=  0, y=  0, z=  0>
    pos=<x=  3, y=  5, z= -1>, vel=<x=  0, y=  0, z=  0>
    """
    test "printing after 0 steps" do
      fun = fn ->
        @input |> Parser.parse() |> Printer.print()
      end

      assert @expected == capture_io(fun)
    end

    @expected_1 """
    After 1 steps:
    pos=<x=  2, y= -1, z=  1>, vel=<x=  3, y= -1, z= -1>
    pos=<x=  3, y= -7, z= -4>, vel=<x=  1, y=  3, z=  3>
    pos=<x=  1, y= -7, z=  5>, vel=<x= -3, y=  1, z= -3>
    pos=<x=  2, y=  2, z=  0>, vel=<x= -1, y= -3, z=  1>
    """
    test "printing after simulating 1 step" do
      fun = fn ->
        @input
        |> Parser.parse()
        |> Simulation.run(1)
        |> Printer.print()
      end

      assert @expected_1 == capture_io(fun)
    end

    @expected_10 """
    After 10 steps:
    pos=<x=  2, y=  1, z= -3>, vel=<x= -3, y= -2, z=  1>
    pos=<x=  1, y= -8, z=  0>, vel=<x= -1, y=  1, z=  3>
    pos=<x=  3, y= -6, z=  1>, vel=<x=  3, y=  2, z= -3>
    pos=<x=  2, y=  0, z=  4>, vel=<x=  1, y= -1, z= -1>
    """
    test "printing after simulating 10 steps" do
      fun = fn ->
        @input
        |> Parser.parse()
        |> Simulation.run(10)
        |> Printer.print()
      end

      assert @expected_10 == capture_io(fun)
    end

    test "total_energy after 10 steps" do
      assert 179 = @input |> Parser.parse() |> Simulation.run(10) |> Simulation.total_energy()
    end

    test "steps until repeat" do
      assert %Simulation{repeats_every: 2772} =
               @input |> Parser.parse() |> Simulation.run_until_repeat()
    end
  end

  describe "here's a second example" do
    @input """
    <x=-8, y=-10, z=0>
    <x=5, y=5, z=10>
    <x=2, y=-7, z=3>
    <x=9, y=-8, z=-3>
    """
    test "total_energy after 100 steps" do
      assert 1940 = @input |> Parser.parse() |> Simulation.run(100) |> Simulation.total_energy()
    end

    test "steps until repeat" do
      assert %Simulation{repeats_every: 4_686_774_924} =
               @input |> Parser.parse() |> Simulation.run_until_repeat()
    end
  end

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 8044 = puzzle_input() |> part_1()
    end
  end

  describe "part_2/1" do
    test_with_puzzle_input do
      assert 362_375_881_472_136 = puzzle_input() |> part_2()
    end
  end
end
