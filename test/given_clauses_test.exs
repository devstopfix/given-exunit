defmodule Given.ClausesTest do
  use ExUnit.Case
  use Given.Case

  setup do
    [a: 1]
  end

  describe "Context" do
    scenario "passed to given", ~s"""
    Given :a is 1
    When :a is incremented
    Then :a is 2
    """
  end

  def given_({:a, :is, 1}, %{a: 1}), do: true
  def when_({:a, :is_incremented}, %{a: 1}), do: true
  def then_({:a, :is, 2}, %{a: 1}), do: true
end
