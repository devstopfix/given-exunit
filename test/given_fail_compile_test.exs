defmodule Given.FailCompileTest do
  use ExUnit.Case
  use Given.Case, fail_compile: true

  scenario "Good", ~s(Given 42)

  # # Uncomment to fail compile
  # @tag :failing_test
  # scenario "Invalid", ~s(Having 42)

  def given_(_, _), do: true
  def when_(_, _), do: false
  def then_(_, _), do: false
end
