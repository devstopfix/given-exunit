defmodule Given.Step do

  @moduledoc """
  Behaviour that documents the return values of a given, when or then step.
  """

  @type context :: map
  @type result :: Keyword.t() | map | [atom] | false
  @type step :: tuple

  @doc """
  Setup the state of the world.

  Normally returns a keyword list of one or more values to be
  appended to the context for future steps.
  """
  @callback given_(context, step) :: result

  @doc """
  Execute the behaviour.

  Normally returns a keyword list of one or more values to be
  appended to the context for future steps.
  """
  @callback when_(context, step) :: result

  @doc """
  Run assertions on the context.

  Normally would not change the context so return an empty list.
  """
  @callback then_(context, step) :: result

end
