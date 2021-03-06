defmodule Adventofcode.Day22SlamShuffle do
  use Adventofcode

  alias __MODULE__.{Cards, Deck, Parser, Shuffler}

  def part_1(input) do
    input
    |> Parser.parse()
    |> Deck.new()
    |> Deck.shuffle()
    |> Deck.position_of(2019)
  end

  defmodule Cards do
    def new(cards), do: cards

    def to_list(cards), do: cards

    def size(cards), do: length(cards)

    def index_of(cards, card), do: cards |> Enum.find_index(&(&1 == card))

    def reverse(cards) do
      Enum.reverse(cards)
    end

    def cut(cards, n) do
      {upper, lower} = Enum.split(cards, n)
      lower ++ upper
    end

    def increment(cards, n) do
      pos = &rem(&1 * n, Cards.size(cards))
      reducer = fn {card, index}, acc -> :array.set(pos.(index), card, acc) end

      cards
      |> Enum.with_index()
      |> Enum.reduce(:array.new(), reducer)
      |> :array.to_list()
    end
  end

  defmodule Shuffler do
    def shuffle(cards, "deal into new stack") do
      Cards.reverse(cards)
    end

    def shuffle(cards, "cut " <> n) do
      n = String.to_integer(n)
      Cards.cut(cards, n)
    end

    def shuffle(cards, "deal with increment " <> n) do
      n = String.to_integer(n)
      Cards.increment(cards, n)
    end
  end

  defmodule Deck do
    defstruct instructions: [], cards: nil

    def new(instructions, range \\ 0..10006)

    def new(instructions, %Range{} = range) do
      new(instructions, range |> Enum.to_list())
    end

    def new(instructions, cards) when is_list(cards) do
      %Deck{instructions: instructions, cards: Cards.new(cards)}
    end

    def shuffle(deck) do
      deck.instructions
      |> Enum.reduce(deck, &%{&2 | cards: Shuffler.shuffle(&2.cards, &1)})
    end

    def to_list(%Deck{cards: cards}), do: Cards.to_list(cards)

    def position_of(%Deck{cards: cards}, card) do
      Cards.index_of(cards, card)
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
