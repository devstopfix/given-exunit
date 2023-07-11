defmodule Given.Parser do
  @moduledoc false
  alias Given.SyntaxError

  @type input :: binary | list

  @spec parse(input) :: {:ok, Keyword.t()} | {:error, term} | {:error, term, pos_integer}
  def parse(b) when is_binary(b), do: b |> to_charlist() |> parse()

  def parse(s) do
    with {:ok, tokens, _} <- :given_lexer.string(s) do
      :given_parser.parse(tokens)
    end
  end

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
