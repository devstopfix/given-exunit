defmodule Given.ParserTest do
  use ExUnit.Case
  use Given.Case

  import Given.Parser, only: [parse!: 2]
  alias Given.SyntaxError

  @tag :failing_test
  scenario "Placeholder fails as not implemented"

  @tag :failing_test
  scenario "Fails at wrong line", ~s"""
  Given 0
  Bang!
  """

  describe "Parse atoms" do
    scenario "Given atom", ~s[Given :a When to string Then a]
  end

  describe "Parse dates" do
    scenario "Given ISO 8601 date", ~s[Given 2014-09-18]
  end

  describe "Parse numbers" do
    scenario "Given zero", ~s[Given 0]
    scenario "Given integer", ~s[Given 1]
    scenario "Given negative integer", ~s[Given -1]
    scenario "Given hexadecimal", ~s[Given 0xFF]
  end

  describe "Parse strings" do
    scenario "Given double quoted string", ~s"""
    Given vessel "Nautilus" commanded by "Captain Nemo"
    """
  end

  describe "Parse givens" do
    scenario "Given precondition", ~s[Given some precondition]

    scenario "Given And", ~s"Given some precondition And some other precondition"

    scenario "Given And multiline", ~s"""
    Given some precondition
    And some other precondition
    """
  end

  describe "Parse scenarios" do
    scenario "Given only", ~s[Given precondition]

    scenario "Given When", ~s"""
    Given precondition
    When command
    """

    scenario "Given When Then", ~s"""
    Given precondition
    When command
    Then postcondition
    """

    scenario "Given & When Then", ~s"""
    Given precondition
    And precondition
    When command
    Then postcondition
    """

    scenario "Given & When & Then", ~s"""
    Given precondition
    And precondition
    When command
    And command
    Then postcondition
    """

    scenario "Given & When & Then &", ~s"""
    Given precondition
    And precondition
    When command
    And command
    Then postcondition
    And then
    """
  end

  describe "Invalid scenarios" do
    test "When without Given" do
      assert_invalid_scenario(~s"""
      When command
      """)
    end

    test "When before Given" do
      assert_invalid_scenario(~s"""
      When command
      Given precondition
      """)
    end
  end

  def assert_invalid_scenario(prose) do
    assert {:error, SyntaxError, _} = parse!(prose, %{file: "", line: 0})
  end

  def given_(_, _), do: nil
  def when_(_, _), do: nil
  def then_(_, _), do: nil
end
