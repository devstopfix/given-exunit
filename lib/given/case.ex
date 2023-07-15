defmodule Given.Case do
  @moduledoc """
  Extend `ExUnit.Case` test cases with feature tests.

  At the top of your test module:

  ```
  defmodule MyApp.FeatureTests do
    use ExUnit.Case, async: true
    use Given.Case
  end

  ```
  A feature is often defined as a set of scenarios. The feature can be achieved
  by grouping scenarios inside a standard ExUnit `describe` block:

  ```elixir
  describe "feature 1" do
    scenario "one", ~s[Given x When y Then z]
  end

  describe "feature 2" do
    scenario "two", ~s""
    Given x
    When y
    Then z
    ""
  end
  ```

  ^ note the doc does not use triple quotes - your test cases should!

  A scenario is a list of clauses. Each clause must start with one of
  GIVEN, WHEN, or THEN in UPPER or Title case. Newlines are counted as
  whitespace when separating clauses and are recommended but not required.

  Clauses must appear in the order GIVEN WHEN THEN. If multiple clauses of the
  same kind are required then AND (or And) can be interspersed:

  ```
  GIVEN pre-condition AND another pre-condition
  WHEN action
  THEN post-condition AND another post-condition
  ```

  The error messages on the parser are not yet very descriptive! If there is
  a problem then a `Given.SyntaxError` will be raised when the test is run
  however you may also fail the compile with this flag:

      use Given.Case, fail_compile: true

  If a scenario is required but has not yet been written you can write a
  failing test as you would in `ExUnit.Case` by writing a placeholder with a
  name but without the prose:

  ```elixir
  describe "Leap seconds" do
    scenario "handle 61 seconds in a minute"
  end
  ```

  Once the scenario is written you must implement the `Given.Step` callbacks
  that match the parsed terms:

  ```elixir
  describe "elixir-lang.org" do
    scenario "peek", ~s""
    Given the string "Elixir"
    When graphemes
    And frequencies
    Then "i" occurs 2 times
    And "E" occurs 1 time
    ""
  end

  # Pre-conditions
  def given_({:the_string, s}, _), do: [str: s]
  # Actions
  def when_({:graphemes}, %{str: s}), do: [gs: String.graphemes(s)]
  def when_({:frequencies}, %{gs: gs}), do: [freq: Enum.frequencies(gs)]
  # Post-conditions
  def then_({l, :occurs, n, _}, %{freq: freq}), do: assert n == freq[l]
  ```

  A pre-condition may return a keyword list of values that are appended to
  the context and passed from clause to clause. `ExUnit.Assertions` can be
  used as normal in the post-conditions.

  You may setup a test context as normal:

  ```elixir
  setup [:setup_a]

  scenario "addition", ~s""
  Given :a
  Then :a is 1
  ""

  def given_(_, _), do: true
  def then_({_, :is, x}, %{a: a}), do: assert a == x

  def setup_a(_context) do
    [a: 1]
  end
  ```
  """

  @doc false
  defmacro __using__(opts) do
    calling_module = __CALLER__.module
    fail_compile = Keyword.get(opts, :fail_compile, false)
    Module.register_attribute(calling_module, :given_fail_compile, accumulate: false)
    Module.put_attribute(calling_module, :given_fail_compile, fail_compile)

    quote do
      import unquote(__MODULE__)
    end
  end

  @doc """
  Defines a named yet not implemented test.

  Provides a convenient macro that allows a test to be defined
  with a string, but not yet implemented. The resulting test will
  always fail and print a "Not implemented" error message. The
  resulting test case is also tagged with `:not_implemented`.

  ## Examples

      scenario "handle leap seconds"

  """
  defmacro scenario(test_name) do
    # Placeholder, not implemented
    %{module: mod, file: file, line: line} = __CALLER__

    quote bind_quoted: [test_name: test_name, mod: mod, file: file, line: line] do
      name = ExUnit.Case.register_test(mod, file, line, :test, test_name, [:not_implemented])
      def unquote(name)(_), do: flunk("Not implemented")
    end
  end

  @doc """
  Defines an ExUnit test with given name and prose.

  The test context cannot be matched but is passed into the first clause. For
  more information on contexts, see `ExUnit.Callbacks`.

  Clauses must appear in the order GIVEN WHEN THEN. If multiple clauses of the
  same kind are required then AND (or And) can be interspersed:

  ## Example

      GIVEN pre-condition AND another pre-condition
      WHEN action
      THEN post-condition AND another post-condition

  """
  defmacro scenario(test_name, prose) do
    %{module: mod, file: file, line: line} = __CALLER__

    quote bind_quoted: [test_name: test_name, mod: mod, file: file, line: line, prose: prose] do
      parsed = Given.Parser.parse!(prose, %{file: file, line: line})
      name = ExUnit.Case.register_test(mod, file, line, :test, test_name, [:scenario])

      case parsed do
        {:ok, steps} ->
          def unquote(name)(context) do
            steps = unquote(Macro.escape(steps))
            Given.Case.execute_steps(context, unquote(mod), steps)
          end

        {:error, error, args} ->
          if Module.get_attribute(mod, :given_fail_compile, false) == true do
            raise error, args
          else
            def unquote(name)(_context) do
              raise unquote(error), unquote(args)
            end
          end
      end
    end
  end

  @doc false
  def execute_steps(context, _mod, []), do: context

  @doc false
  def execute_steps(context, mod, [{step, args} | steps]) do
    result = apply(mod, step, [args, context])

    new_context =
      case result do
        true ->
          context

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

        :error ->
          raise RuntimeError, "Step #{inspect(step)} with #{inspect(args)}"

        {:error, error} ->
          raise RuntimeError,
                "Step #{inspect(step)} with #{inspect(args)} returned #{inspect(error)}"

        _ ->
          context
      end

    execute_steps(new_context, mod, steps)
  end
end
