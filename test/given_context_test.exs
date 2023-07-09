defmodule Given.ContextTest do
  use ExUnit.Case
  use Given.Case

  setup do
    [a: 1]
  end

  describe "Context" do
    scenario "passed to given", ~s[Given :a is 1]

    scenario "appended", ~s"""
    Given :a is 1
    When :b is 2
    Then both
    """

    scenario "steps append to context", ~s"""
    Given :b is 2
    When :c equals :a plus :b
    Then :c equals 3
    """

    scenario "steps can leave context unchanged", ~s"""
    Given :a is 1
    When nop
    Then :a is 1
    """

    scenario "steps can remove from context", ~s"""
    Given :b is 1
    When delete :a
    Then :b replaced :a
    """

    # TODO enable
    # scenario "steps can fail the test", ~s"""
    # Given :a is 1
    # When fail
    # Then :a is 66
    # """
  end

  def given_({:a, :is, 1}, %{a: 1}), do: true

  def given_({:b, :is, n}, _), do: [b: n]

  def when_({:c, :equals, :a, :plus, :b}, %{a: a, b: b}), do: [c: a + b]

  def when_({:b, :is, n}, %{a: 1}), do: [b: n]

  def when_({:nop}, _), do: []

  def when_({:delete, key}, _) when key in [:a], do: [key]

  def when_({:fail}, _), do: false

  def then_({:c, :equals, expected}, %{c: c}), do: assert(c == expected)

  def then_({:both}, %{a: 1, b: 2}), do: true

  def then_({:a, :is, expected}, %{a: a}), do: assert(a == expected)

  def then_({:b, :replaced, :a}, %{b: 1} = context) do
    refute Map.has_key?(context, :a)
    true
  end
end
