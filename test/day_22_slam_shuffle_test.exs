defmodule Adventofcode.Day22SlamShuffleTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day22SlamShuffle

  alias Adventofcode.Day22SlamShuffle.{Deck, Parser}

  describe "Deck.shuffle/2" do
    test "deal into new stack" do
      assert [9, 8, 7, 6, 5, 4, 3, 2, 1, 0] =
               "deal into new stack"
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
               |> Deck.to_list()
    end

    test "cut 3" do
      assert [3, 4, 5, 6, 7, 8, 9, 0, 1, 2] =
               "cut 3"
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
               |> Deck.to_list()
    end

    test "cut -4" do
      assert [6, 7, 8, 9, 0, 1, 2, 3, 4, 5] =
               "cut -4"
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
               |> Deck.to_list()
    end

    test "deal with increment 3" do
      assert [0, 7, 4, 1, 8, 5, 2, 9, 6, 3] =
               "deal with increment 3"
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
               |> Deck.to_list()
    end

    @input """
    deal with increment 7
    deal into new stack
    deal into new stack
    """
    test "deal with increment 7 deal into new stack deal into new stack" do
      assert [0, 3, 6, 9, 2, 5, 8, 1, 4, 7] =
               @input
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
               |> Deck.to_list()
    end

    @input """
    cut 6
    deal with increment 7
    deal into new stack
    """
    test "cut 6 deal with increment 7 deal into new stack" do
      assert [3, 0, 7, 4, 1, 8, 5, 2, 9, 6] =
               @input
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
               |> Deck.to_list()
    end

    @input """
    deal with increment 7
    deal with increment 9
    cut -2
    """
    test "deal with increment 7 deal with increment 9 cut -2" do
      assert [6, 3, 0, 7, 4, 1, 8, 5, 2, 9] =
               @input
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
               |> Deck.to_list()
    end
  end

  describe "part_1/1" do
    @tag :slow
    test_with_puzzle_input do
      assert 3324 = puzzle_input() |> part_1()
    end
  end
end
