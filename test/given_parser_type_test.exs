defmodule Given.ParserTypesTest do
  use ExUnit.Case
  use Given.Case

  describe "Parse type" do
    scenario "date", ~s[Given date 2014-09-18]
    scenario "float", ~s[Given float 1.6180]
    scenario "integer", ~s[Given integer 0]
    scenario "range", ~s[Given die rolls 1-6]
    scenario "string", ~s[Given string "a & b"]
    scenario "time", ~s[Given time 17:00:59]
  end

  def given_({:date, ~D[2014-09-18]}, _), do: true
  def given_({:die_rolls, 1..6}, _), do: true
  def given_({:float, 1.6180}, _), do: true
  def given_({:integer, 0}, _), do: true
  def given_({:string, "a & b"}, _), do: true
  def given_({:time, ~T[17:00:59]}, _), do: true
  def when_(_, _), do: false
  def then_(_, _), do: false
end
