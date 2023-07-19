defmodule Given.AndClausesTest do
  use ExUnit.Case
  use Given.Case

  setup do
    [acc: []]
  end

  describe "Given" do
    scenario "and", ~s"""
    Given 1
    And 2
    Then acc is 2
    """

    scenario "and and", ~s"""
    Given 1
    And 2
    And 3
    Then acc is 3
    """

    scenario "and and and", ~s"""
    Given 1
    And 2
    And 3
    And 4
    Then acc is 4
    """

    # scenario "and and when and and", ~s"""
    # Given 1
    # And 2
    # And 3
    # When 4
    # And 5
    # And 6
    # Then acc is 6
    # """
  end

  def given_({n}, _) when is_integer(n),
    do: fn ctx -> Map.update!(ctx, :acc, &Enum.concat(&1, [n])) end

  def when_({n}, _) when is_integer(n),
    do: fn ctx -> Map.update!(ctx, :acc, &Enum.concat(&1, [n])) end

  def then_({:acc_is, n}, %{acc: acc}) when is_integer(n), do: assert(Enum.to_list(1..n) == acc)
end
