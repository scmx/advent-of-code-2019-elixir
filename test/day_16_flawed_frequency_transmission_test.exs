defmodule Adventofcode.Day16FlawedFrequencyTransmissionTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day16FlawedFrequencyTransmission
  alias Adventofcode.Day16FlawedFrequencyTransmission.{FFT, Parser}

  @expected [
    [1, 0, -1, 0, 1, 0, -1, 0],
    [0, 1, 1, 0, 0, -1, -1, 0],
    [0, 0, 1, 1, 1, 0, 0, 0],
    [0, 0, 0, 1, 1, 1, 1, 0],
    [0, 0, 0, 0, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 1]
  ]
  test "pattern" do
    assert @expected == "11111111" |> Parser.parse() |> FFT.pattern()
  end

  describe "run" do
    test "run to phase 1" do
      assert %FFT{phase: 1, signal: [4, 8, 2, 2, 6, 1, 5, 8]} ==
               "12345678" |> Parser.parse() |> FFT.run(1)
    end

    test "run to phase 2" do
      assert %FFT{phase: 2, signal: [3, 4, 0, 4, 0, 4, 3, 8]} ==
               "12345678" |> Parser.parse() |> FFT.run(2)
    end

    test "run to phase 3" do
      assert %FFT{phase: 3, signal: [0, 3, 4, 1, 5, 5, 1, 8]} ==
               "12345678" |> Parser.parse() |> FFT.run(3)
    end
  end

  describe "part_1/1" do
    test_with_puzzle_input do
      assert "82525123" = puzzle_input() |> part_1()
    end
  end
end
