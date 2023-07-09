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
  end

  describe "Context append" do
    scenario "steps append to context", ~s"""
    Given :b is 2
    When :c equals :a plus :b
    Then :c equals 3
    """
  end

  describe "Context unchanged" do
    scenario "steps can leave context unchanged", ~s"""
    Given :a is 1
    When nop
    Then :a is 1
    """
  end

  def given_(%{a: 1}, {:a, :is, 1}), do: true

  def given_(_, {:b, :is, n}), do: [b: n]

  def when_(%{a: a, b: b}, {:c, :equals, :a, :plus, :b}), do: [c: a + b]

  def when_(%{a: 1}, {:b, :is, n}), do: [b: n]

  def when_(_, {:nop}), do: []

  def then_(%{c: c}, {:c, :equals, expected}), do: assert c == expected

  def then_(%{a: 1, b: 2}, {:both}), do: true

  def then_(%{a: a}, {:a, :is, expected}), do: assert a == expected
end
