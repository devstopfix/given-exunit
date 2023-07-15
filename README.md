# Given ExUnit

Given-When-Then is a style of representing tests of specifying a system's
behaviour using specification by example - [Martin Fowler][gwt].

This is a micro library that is a lite extension to ExUnit and prefers 
pattern matching over regular expressions. There are other BDD libraries
but they do not seem to be maintained. The advantages of Given are:

1. no regular expressions
2. pattern match errors are clear and obvious
3. line numbers in errors are accurate as there are no separate text files

We use a parser to split clauses into words, strings, integers and dates then
call functions and rely on pattern matching to build up a test state. The input
is the standard context created with the `setup` and `setup_all` callbacks
and this context is passed from clause to clause with new data appended.

Here is a working example using the [peek at elixir-lang.org][ex]:

```elixir
defmodule Given.ReadmeTest do
  use ExUnit.Case
  use Given.Case

  describe "elixir-lang.org" do
    scenario "peek", ~s"""
    Given the string "Elixir"
    When graphemes
    And frequencies
    Then "i" occurs 2 times
    And "E" occurs 1 time
    """
  end

  # Pre-conditions
  def given_({:the_string, s}, _), do: [str: s]
  # Actions
  def when_({:graphemes}, %{str: s}), do: [gs: String.graphemes(s)]
  def when_({:frequencies}, %{gs: gs}), do: [freq: Enum.frequencies(gs)]
  # Post-conditions
  def then_({l, :occurs, n, _}, %{freq: freq}), do: assert n == freq[l]
end
```

See the [Case module][case] for the syntax of the scenarios and 
the [Parser module][parser] contains the terms that can be used.

[![CI](https://github.com/devstopfix/given-exunit/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/devstopfix/given-exunit/actions/workflows/ci.yml)

## Installation

```elixir
def deps do
  [
    {:given, "~> 1.22", only: [:test, :dev]}
  ]
end
```

### Testing

When changing the grammar or the parser, run tests with:

    PROPCHECK_NUMTESTS=20000 mix test

Run deliberately failing tests with:

    mix test --only failing_test


[case]: https://hexdocs.pm/given_exunit/Given.Case.html
[parser]: https://hexdocs.pm/given_exunit/Given.Parser.html
[docs]: https://hexdocs.pm/given_exunit
[ex]: https://elixir-lang.org
[gwt]: https://martinfowler.com/bliki/GivenWhenThen.html