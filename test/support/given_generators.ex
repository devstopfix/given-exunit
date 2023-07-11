defmodule Given.Generators do
  @moduledoc false
  use PropCheck

  import Given.DateTimeGenerators

  def scenario do
    let {root, ands} <- {given_clause(), and_clauses()} do
      [root | ands]
      |> List.flatten()
      |> Enum.join()
    end
  end

  def given_clause do
    let {prefix, terms, lf} <- {given(), terms(), clause_separator()} do
      [prefix, terms, lf]
    end
  end

  def and_clauses do
    let n <- elements([exactly(0), integer(0, 3)]) do
      let clauses <- vector(n, and_clause()) do
        clauses
      end
    end
  end

  def and_clause do
    let {prefix, terms, lf} <- {and_(), terms(), clause_separator()} do
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
        iso8601_time(),
        hex_string(),
        word(),
        atom_()
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

  def hex_digit,
    do:
      elements([
        elements(Enum.to_list(?0..?9) ++ Enum.to_list(?a..?f)),
        elements(Enum.to_list(?0..?9) ++ Enum.to_list(?A..?F))
      ])

  def hex_string do
    let n <- integer(1, 8) do
      let digits <- vector(n, hex_digit()) do
        to_string([?0, ?x | digits])
      end
    end
  end

  def atom_ do
    let a <- elements(~w[a bb ccc ddd]a) do
      inspect(a)
    end
  end

  def word, do: elements(~w[and or not xor])

  defp cases(s), do: [s, String.upcase(s)]
end
