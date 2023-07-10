defmodule Given.StringTest do
  use ExUnit.Case
  use Given.Case

  describe "Strings" do
    scenario "double quoted", ~s"""
    Given "Nautilus"
    """

    scenario "two double quoted", ~s"""
    Given vessel "Nautilus" commanded by "Captain Nemo"
    """
  end

  def given_({"Nautilus"}, _), do: true
  def given_({:vessel, "Nautilus", :commanded_by, "Captain Nemo"}, _), do: true
end
