defmodule Adventofcode.Day08SpaceImageFormatTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day08SpaceImageFormat

  describe "least_corrupted_layer/1" do
    test "given an image 3 pixels wide and 2 pixels tall" do
      assert 1 = "123456789012" |> least_corrupted_layer({3, 2})
    end
  end

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 1441 = puzzle_input() |> part_1({25, 6})
    end
  end
end
