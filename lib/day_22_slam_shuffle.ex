defmodule Adventofcode.Day22SlamShuffle do
  use Adventofcode

  alias __MODULE__.{Deck, Parser, Shuffler}

  def part_1(input) do
    input
    |> Parser.parse()
    |> Deck.new()
    |> Deck.shuffle()
    |> Deck.position_of(2019)
  end

  defmodule Shuffler do
    def shuffle(cards, "deal into new stack") do
      Enum.reverse(cards)
    end

    def shuffle(cards, "cut " <> n) do
      n = String.to_integer(n)
      {upper, lower} = Enum.split(cards, n)
      lower ++ upper
    end

    def shuffle(cards, "deal with increment " <> n) do
      n = String.to_integer(n)
      pos = &rem(&1 * n, length(cards))
      reducer = fn {card, index}, acc -> :array.set(pos.(index), card, acc) end

      cards
      |> Enum.with_index()
      |> Enum.reduce(:array.new(), reducer)
      |> :array.to_list()
    end
  end

  defmodule Deck do
    defstruct instructions: [], cards: []

    def new(instructions, range \\ 0..10006)

    def new(instructions, %Range{} = range) do
      new(instructions, range |> Enum.to_list())
    end

    def new(instructions, cards) when is_list(cards) do
      %Deck{instructions: instructions, cards: cards}
    end

    def shuffle(deck) do
      deck.instructions
      |> Enum.reduce(deck, &%{&2 | cards: Shuffler.shuffle(&2.cards, &1)})
    end

    def to_list(deck), do: deck.cards

    def position_of(deck, card) do
      Enum.find_index(deck.cards, &(&1 == card))
    end
  end

  defmodule Parser do
    def parse(input) do
      input
      |> String.trim_trailing("\n")
      |> String.split("\n")
    end
  end
end
