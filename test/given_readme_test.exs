defmodule Given.ReadmeTest do
  use ExUnit.Case
  use Given.Case

  describe "elixir-lang.org" do
    scenario "peek", ~s"""
    Given the string "Elixir"
    When graphemes
    And frequencies
    Then "i" occurs 2 times
    And "E" occurs 1 time
    """
  end

  # Pre-conditions
  def given_({:the_string, s}, _), do: [str: s]
  # Actions
  def when_({:graphemes}, %{str: s}), do: [gs: String.graphemes(s)]
  def when_({:frequencies}, %{gs: gs}), do: [freq: Enum.frequencies(gs)]
  # Post-conditions
  def then_({l, :occurs, n, _}, %{freq: freq}), do: assert(n == freq[l])
end
