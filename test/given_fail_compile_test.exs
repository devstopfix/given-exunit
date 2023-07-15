defmodule Given.FailCompileTest do
  use ExUnit.Case
  use Given.Case, fail_compile: true

  scenario "Good", ~s(Given 42)

  @tag :failing_test
  scenario "Invalid", ~s(Having 42)

  def given_(_, _), do: true
end
