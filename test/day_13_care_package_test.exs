defmodule Adventofcode.Day13CarePackageTest do
  use Adventofcode.FancyCase

  alias Adventofcode.Day13CarePackage.ArcadeCabinet

  import Adventofcode.Day13CarePackage

  describe "Tiles.put/3" do
    test "1,2,3 would draw a horizontal paddle tile (1 tile from the left and 2 tiles from the top)" do
      assert %ArcadeCabinet{tiles: %{{1, 2} => :horizontal_paddle}} =
               %ArcadeCabinet{} |> ArcadeCabinet.draw([[1, 2, 3]])
    end

    test "6,5,4 would draw a ball tile (6 tiles from the left and 5 tiles from the top)" do
      assert %ArcadeCabinet{tiles: %{{6, 5} => :ball}} =
               %ArcadeCabinet{} |> ArcadeCabinet.draw([[6, 5, 4]])
    end
  end

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 363 = puzzle_input() |> part_1()
    end
  end
end
