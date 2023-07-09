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
  alias Mix.Tasks.Run

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

  defmacro scenario(test_name, prose) do
    %{module: mod, file: file, line: line} = __CALLER__

    steps =
      quote bind_quoted: [prose: prose] do
        {:ok, steps} = Given.Parser.parse!(prose, %{file: file, line: line})
        steps
      end

    quote bind_quoted: [test_name: test_name, mod: mod, file: file, line: line, steps: steps] do
      name = ExUnit.Case.register_test(mod, file, line, :test, test_name, [:scenario])

      def unquote(name)(context) do
        steps = unquote(Macro.escape(steps))
        Given.Case.execute_steps(context, unquote(mod), steps)
      end
    end
  end

  def execute_steps(context, _mod, []), do: context

  def execute_steps(context, mod, [{step, args} | steps]) do
    result = apply(mod, step, [context, args])

    new_context =
      case result do
        [] ->
          context

        [{k, _v} | _] when is_atom(k) ->
          Enum.reduce(result, context, fn {k, v}, acc ->
            Map.put(acc, k, v)
          end)

        [k | _] = ks when is_atom(k) ->
          Map.drop(context, ks)

        false ->
          raise RuntimeError, inspect(args)

        _ ->
          context
      end

    execute_steps(new_context, mod, steps)
  end
end
