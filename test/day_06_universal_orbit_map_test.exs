defmodule Adventofcode.Day06UniversalOrbitMapTest do
  use Adventofcode.FancyCase

  alias Adventofcode.Day06UniversalOrbitMap.Orbits

  import Adventofcode.Day06UniversalOrbitMap

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
      assert %Orbits{direct: 11, indirect: 31} = @input |> new()
    end
  end

  describe "minimum_number_of_orbital_transfers_required/1" do
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
    K)YOU
    I)SAN
    """
    test "suppose you have the following map" do
      assert %Orbits{
               transfers: %{
                 "YOU" => ["COM", "B", "C", "D", "E", "J", "K", "YOU"],
                 "SAN" => ["COM", "B", "C", "D", "I", "SAN"]
               }
             } = @input |> new()
    end
  end

  describe "part_1/1" do
    test_with_puzzle_input do
      assert 270_768 = puzzle_input() |> part_1()
    end
  end

  describe "part_2/1" do
    test_with_puzzle_input do
      assert 451 = puzzle_input() |> part_2()
    end

    test "suppose you have the following map" do
      assert 4 =
               @input
               |> new()
               |> Orbits.distance("YOU", "SAN")
    end
  end
end
