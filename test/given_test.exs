defmodule GivenTest do
  use ExUnit.Case
  use Given.Case

  # feature "first"

  # Uncomment to see "Not implemented"
  # scenario "Placeholder"

  # # Uncomment to see error at line 11 (off by one!)
  # scenario "Fails", ~s"""
  # Given 0
  # Bang!
  # """

  # scenario "Given", ~s[Given]

  describe "Parse atoms" do
    scenario "Given atom", ~s[Given :a]
  end

  describe "Parse numbers" do
    scenario "Given zero", ~s[Given 0]
    scenario "Given integer", ~s[Given 1]
    scenario "Given negative integer", ~s[Given -1]
    # scenario "Given hexadecimal", ~s[Given 0xFF]
  end

  describe "Parse dates" do
    scenario "Given ISO 8601 date", ~s[Given 2014-09-18]
  end

  describe "Parse sentence" do
    scenario "Given some precondition", ~s[Given some precondition]
  end

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
