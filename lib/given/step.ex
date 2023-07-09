defmodule Given.Step do
  @moduledoc """
  Behaviour that documents the return values of a given, when or then step.
  """

  @typedoc "ExUnit test case context"
  @type context :: map

  @typedoc """
  Return of each step has the following effect on the context:
  * empty list - no effect
  * false - fail with a RuntimeError
  * list of atoms - remove the given keys from the context
  * keyword list - put the items into the context
  * other - context is not changed
  * true - context is not changed
  """
  @type result :: Keyword.t() | map | [atom] | false | true

  @typedoc "Tuple representing the parsed clause"
  @type step :: tuple

  @doc """
  Setup the state of the world.

  Normally returns a keyword list of one or more values to be
  appended to the context for future steps.
  """
  @callback given_(step, context) :: result

  @doc """
  Execute the behaviour.

  Normally returns a keyword list of one or more values to be
  appended to the context for future steps.
  """
  @callback when_(step, context) :: result

  @doc """
  Run assertions on the context.

  Normally would not change the context so return an empty list.
  """
  @callback then_(step, context) :: boolean
end
