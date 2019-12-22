defmodule Adventofcode.Day22SlamShuffleTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day22SlamShuffle

  alias Adventofcode.Day22SlamShuffle.{Deck, Parser}

  describe "Deck.shuffle/2" do
    test "deal into new stack" do
      expected = Enum.to_list(9..0)

      assert %Deck{cards: ^expected} =
               "deal into new stack"
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
    end

    test "cut 3" do
      expected = [3, 4, 5, 6, 7, 8, 9, 0, 1, 2]

      assert %Deck{cards: ^expected} =
               "cut 3"
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
    end

    test "cut -4" do
      expected = [6, 7, 8, 9, 0, 1, 2, 3, 4, 5]

      assert %Deck{cards: ^expected} =
               "cut -4"
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
    end

    test "deal with increment 3" do
      expected = [0, 7, 4, 1, 8, 5, 2, 9, 6, 3]

      assert %Deck{cards: ^expected} =
               "deal with increment 3"
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
    end

    @input """
    deal with increment 7
    deal into new stack
    deal into new stack
    """
    test "deal with increment 7 deal into new stack deal into new stack" do
      expected = [0, 3, 6, 9, 2, 5, 8, 1, 4, 7]

      assert %Deck{cards: ^expected} =
               @input
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
    end

    @input """
    cut 6
    deal with increment 7
    deal into new stack
    """
    test "cut 6 deal with increment 7 deal into new stack" do
      expected = [3, 0, 7, 4, 1, 8, 5, 2, 9, 6]

      assert %Deck{cards: ^expected} =
               @input
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
    end

    @input """
    deal with increment 7
    deal with increment 9
    cut -2
    """
    test "deal with increment 7 deal with increment 9 cut -2" do
      expected = [6, 3, 0, 7, 4, 1, 8, 5, 2, 9]

      assert %Deck{cards: ^expected} =
               @input
               |> Parser.parse()
               |> Deck.new(0..9)
               |> Deck.shuffle()
    end
  end

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 3324 = puzzle_input() |> part_1()
    end
  end
end
