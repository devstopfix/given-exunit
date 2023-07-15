defmodule Given.StepErrorTest do
  use ExUnit.Case
  use Given.Case

  describe "Errors" do
    @tag :failing_test
    scenario "error atom", ~s"""
    Given bang
    """

    @tag :failing_test
    scenario "error tuple", ~s"""
    Given bangbang
    """
  end

  def given_({:bang}, _), do: :error
  def given_({:bangbang}, _), do: {:error, :bang}
end
