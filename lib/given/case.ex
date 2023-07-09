defmodule Given.Case do
  @moduledoc """
  Extend ExUnit test cases with feature tests.

  At the top of your test module:

  ```
  defmodule MyApp.AppTests do
    use ExUnit.Case, async: ...
    use Given.Case
  end
  ```

  """

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  # Placeholder, not implemented
  defmacro scenario(test_name) do
    %{module: mod, file: file, line: line} = __CALLER__

    quote bind_quoted: [test_name: test_name, mod: mod, file: file, line: line] do
      name = ExUnit.Case.register_test(mod, file, line, :test, test_name, [:not_implemented])
      def unquote(name)(_), do: flunk("Not implemented")
    end
  end

  # https://github.com/elixir-lang/elixir/blob/999ecf73de9b84f3c0a947401a2ca8459a9dbd1a/lib/ex_unit/lib/ex_unit/case.ex#L344
  defmacro scenario(test_name, prose) do
    # TODO add line number to parser error line!
    %{module: mod, file: file, line: line} = __CALLER__

    quote bind_quoted: [test_name: test_name, mod: mod, file: file, line: line, prose: prose] do
      {:ok, [{:given_, args} | _]} = Given.Parser.parse!(prose, %{file: file, line: line})
      name = ExUnit.Case.register_test(mod, file, line, :test, test_name, [:feature])

      def unquote(name)(_context) do
        apply(unquote(mod), :given_, unquote(Macro.escape(args)))
      end
    end
  end
end
