defmodule Given.Step do
  @moduledoc """
  Behaviour that documents the return values of a Given, When or Then step.
  """

  @typedoc "ExUnit test case context"
  @type context :: map

  @typedoc """
  Return of each step has the following effect on the context:
  * empty list - no effect
  * :error - fail with a RuntimeError
  * {:error, _} - fail with a RuntimeError
  * false - fail with a RuntimeError
  * list of atoms - remove the given keys from the context
  * keyword list - put the items into the context
  * other - ignored and context is not changed
  * true - context is not changed
  """
  @type result :: Keyword.t() | map | [atom] | :error | {:error, any} | false | true

  @typedoc "Tuple representing the parsed clause"
  @type step :: tuple

  @doc """
  Setup the state of the world.

  Normally returns a keyword list of one or more values to be
  appended to the context for future steps.

  Note the trailing underscore to be consistent with `when_`.
  """
  @callback given_(step, context) :: result

  @doc """
  Execute the behaviour.

  Normally returns a keyword list of one or more values to be
  appended to the context for future steps.

  `when` is a reserved keyword in Elixir and so we use `when_`.
  """
  @callback when_(step, context) :: result

  @doc """
  Run assertions on the context.

  Normally would not change the context so return the result of an assertion.
  Note the trailing underscore to be consistent with `when_`.
  """
  @callback then_(step, context) :: result
end
