defmodule Given.SyntaxError do
  defexception [:message]

  @impl true
  def exception(error: error, file: file, line: line) when is_integer(line) do
    msg = "Error #{inspect(error)} at #{to_string(file)}:#{to_string(line)}}"
    %__MODULE__{message: msg}
  end
end
