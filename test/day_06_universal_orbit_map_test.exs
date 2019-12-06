defmodule Adventofcode.Day06UniversalOrbitMapTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day06UniversalOrbitMap
  import Adventofcode.Day06UniversalOrbitMap.Orbits

  describe "total_number_of_direct_and_indirect_orbits/1" do
    @input """
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    """
    test "suppose you have the following map" do
      assert %Orbits{direct: 11, indirect: 31} =
               @input |> total_number_of_direct_and_indirect_orbits()
    end
  end

  describe "part_1/1" do
    # test "" do
    #   assert 1337 = input |> part_1()
    # end

    test_with_puzzle_input do
      assert 270_768 = puzzle_input() |> part_1()
    end
  end
end
