defmodule GivenTest do
  use ExUnit.Case
  use Given.Case

  # feature "first"

  # Uncomment to see "Not implemented"
  #scenario "Placeholder"

  # scenario "Given", ~s[Given]

  describe "Parse atoms" do
    scenario "Given atom", ~s[Given :a]
  end

  describe "Parse numbers" do
    scenario "Given zero", ~s[Given 0]
    scenario "Given integer", ~s[Given 1]
    scenario "Given negative integer", ~s[Given -1]
  end

  describe "Parse dates" do
    scenario "Given ISO 8601 date", ~s[Given 2014-09-18]
  end

  # feature "second", ~s()

  # feature("""
  # Some terse yet descriptive text of what is desired
  # In order to realize a named business value
  # As an explicit system actor
  # I want to gain some beneficial outcome which furthers the goal
  # """)

  # scenario "test name", %{} do
  #   given("some precondition")
  #   and_("some other precondition")
  #   when_("some action by the actor")
  #   and_("some other action")
  #   and_("yet another action")
  #   then("some testable outcome is achieved")
  #   and_("something else we can check happens too")
  # end

  # scenario "other test", %{} do
  #   [
  #     given: ["some precondition"],
  #     and: ["some other precondition"],
  #     when: ["some action by the actor"],
  #     and: ["some other action"],
  #     and: ["yet another action"],
  #     then: ["some testable outcome is achieved"],
  #     and: ["something else we can check happens too"]
  #   ]
  # end

  # scenario "test with prose" do
  #   ~s"""
  #    Given some precondition
  #    And some other precondition
  #    When some action by the actor
  #    And some other action
  #    And yet another action
  #    Then some testable outcome is achieved
  #    And something else we can check happens too
  #   """
  # end

  defp then(false), do: false
  defp then(true), do: true
end
