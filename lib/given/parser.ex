defmodule Given.Parser do
  @moduledoc """
  Parse a textual scenario into a keyword list of clauses.

  See `Given.Case` for a description on how to structure your features and
  scenarios, what follows are the rules inside a scenario.

  A scenario is a list of clauses. Each clause must start with one of
  GIVEN, WHEN, or THEN in UPPER or Title case. The remainder of a clause is
  split into terms and passed to your code as a tuple.

  There are some restrictions on the terms supported - more flexibility and
  more terms will be added.

  The following terms are supported:

  * atoms - only simple roman alphabet with colon prefix e.g. `:abc`
  * dates - ISO-8601 in the format `YYYY-MM-DD` becomes `Date`
  * hexadecimal - with `0x` prefix e.g. `0xFE` is 254
  * integer - positive and negative base 10 without separators
  * range - a dashed pair of positive integers e.g. `1-6` becomes `1..6`
  * string - any unicode chars within double quotes (no escaping of quotes)
  * time - ISO-8601 in the format `HH:MM:SS` becomes `Time`
  * words - only using the Roman alphabet (temporary restriction!)

  Not currently supported but planned:
  * atoms with extended alphabet
  * date times
  * floats
  * lists
  * time locale
  * words using any alphabet

  Any consecutive words will be collapsed into a single atom. For example
  the words "the cat sat on the mat" becomes `:the_cat_sat_on_the_mat`

  The clause:

      "Elîxir 1.0" was released 2014-09-18

  becomes the tuple:

      {"Elîxir 1.0", :was_released, ~D[2014-09-18]}

  """

  alias Given.SyntaxError

  @type input :: binary | list

  @doc "Parse a textual scenario into a keyword list of clauses"
  @spec parse(input) :: {:ok, Keyword.t()} | {:error, term} | {:error, term, pos_integer}
  def parse(b) when is_binary(b), do: b |> to_charlist() |> parse()

  def parse(s) do
    with {:ok, tokens, _} <- :given_lexer.string(s) do
      :given_parser.parse(tokens)
    end
  end

  @doc """
  Parse a textual scenario into a keyword list of clauses.

  Intended for internal use - expects the `__CALLER__` struct to be supplied
  and fails fast by raising an error.
  """
  @spec parse!(input, map) :: {:ok, Keyword.t()} | no_return
  def parse!(prose, %{file: file, line: line}) do
    case parse(prose) do
      {:ok, result} ->
        {:ok, result}

      {:error, {sub_line, :given_lexer, error}, _} ->
        raise SyntaxError, error: error, file: file, line: line + sub_line - 1

      {:error, {sub_line, :given_parser, error}} ->
        raise SyntaxError, error: error, file: file, line: line + sub_line - 1
    end
  end
end
