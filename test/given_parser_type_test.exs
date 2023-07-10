defmodule Given.ParserTypesTest do
  use ExUnit.Case
  use Given.Case

  describe "Parse type" do
    scenario "date", ~s[Given date 2014-09-18]
    scenario "integer", ~s[Given integer 0]
    scenario "range", ~s[Given die rolls 1-6]
    scenario "string", ~s[Given string "a & b"]
  end

  def given_({:date, ~D[2014-09-18]}, _), do: true
  def given_({:integer, 0}, _), do: true
  def given_({:die_rolls, 1..6}, _), do: true
  def given_({:string, "a & b"}, _), do: true
end
