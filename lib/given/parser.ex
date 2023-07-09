defmodule Given.Parser do
  @moduledoc false
  alias Given.SyntaxError

  def parse(b) when is_binary(b), do: b |> to_charlist() |> parse()

  def parse(s) do
    with {:ok, tokens, _} <- :given_lexer.string(s),
         {:ok, result} <- :given_parser.parse(tokens) do
      result = Enum.reject(result, &is_nil/1)
      {:ok, result}
    end
  end

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
