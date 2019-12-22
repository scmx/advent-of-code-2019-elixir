defmodule Adventofcode.Day22SlamShuffle do
  use Adventofcode

  alias __MODULE__.{Deck, Parser}

  def part_1(input) do
    input
    |> Parser.parse()
    |> Deck.new()
    |> Deck.shuffle()
    |> Deck.position_of(2019)
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
      Enum.reduce(deck.instructions, deck, &shuffle(&2, &1))
    end

    def shuffle(deck, "deal into new stack") do
      %{deck | cards: Enum.reverse(deck.cards)}
    end

    def shuffle(deck, "cut " <> n) do
      n = String.to_integer(n)
      {upper, lower} = Enum.split(deck.cards, n)
      %{deck | cards: lower ++ upper}
    end

    def shuffle(deck, "deal with increment " <> n) do
      n = String.to_integer(n)

      Enum.reduce(Enum.with_index(deck.cards), deck, fn {card, index}, acc ->
        %{
          acc
          | cards: List.update_at(acc.cards, rem(index * n, length(deck.cards)), fn _ -> card end)
        }
      end)
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
