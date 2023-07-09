defmodule Given.ContextTest do
  use ExUnit.Case
  use Given.Case

  import Given.Parser, only: [parse!: 2]

  setup do
    [a: 1]
  end

  describe "Context" do
    scenario "passed to given", ~s[Given :a is 1]
  end

  def given_(%{a: 1}, [:a, :is, 1]), do: true
end
