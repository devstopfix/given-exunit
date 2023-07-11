defmodule Given.Generators do
  @moduledoc false
  use PropCheck

  import Given.DateTimeGenerators

  def scenario do
    let root <- given_clause() do
      root
      |> List.flatten()
      |> Enum.join()
    end
  end

  def given_clause do
    let {prefix, terms, lf} <- {given(), terms(), clause_separator()} do
      [prefix, terms, lf]
    end
  end

  def clause_separator, do: elements([" ", "\t", "\n"])
  def whitespace, do: elements([" "])

  def given, do: "Given" |> cases() |> elements()
  def when_, do: "When" |> cases() |> elements()
  def then_, do: "Then" |> cases() |> elements()
  def and_, do: "And" |> cases() |> elements()

  def any_term,
    do:
      elements([
        pos_integer(),
        neg_integer(),
        integer(),
        iso8601_date(),
        iso8601_time()
      ])

  def pad_term do
    let {ws, trm} <- {whitespace(), any_term()} do
      [ws, trm]
    end
  end

  def terms do
    let n <- integer(1, 5) do
      let terms <- vector(n, pad_term()) do
        terms
      end
    end
  end

  defp cases(s), do: [s, String.upcase(s)]
end
