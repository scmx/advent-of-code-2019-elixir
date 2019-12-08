defmodule Adventofcode.Day08SpaceImageFormatTest do
  use Adventofcode.FancyCase

  import ExUnit.CaptureIO
  import Adventofcode.Day08SpaceImageFormat

  describe "least_corrupted_layer/1" do
    test "given an image 3 pixels wide and 2 pixels tall" do
      assert 1 = "123456789012" |> least_corrupted_layer({3, 2})
    end
  end

  describe "render_pixels/1" do
    @output ~h"""
     1
    1
    """
    test "0222112222120000" do
      fun = fn -> "0222112222120000" |> part_2({2, 2}) end

      assert capture_io(fun) == @output
    end
  end

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 1441 = puzzle_input() |> part_1({25, 6})
    end
  end

  describe "part_2/1" do
    @output ~h"""
    111  1  1 1111 111  111
    1  1 1  1    1 1  1 1  1
    1  1 1  1   1  111  1  1
    111  1  1  1   1  1 111
    1 1  1  1 1    1  1 1
    1  1  11  1111 111  1
    """
    test_with_puzzle_input do
      fun = fn -> puzzle_input() |> part_2({25, 6}) end

      assert capture_io(fun) == @output
    end
  end
end
