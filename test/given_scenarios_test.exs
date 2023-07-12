defmodule Given.ScenariosTest do
  use ExUnit.Case
  use PropCheck

  import Given.Generators, only: [scenario: 0]
  import Given.Parser, only: [parse: 1]

  property "Parse scenario" do
    p =
      forall scenario <- scenario() do
        {:ok, _} = parse(scenario)
        true
      end

    numtests(env_numtests(), p)
  end

  defp env_numtests do
    with s <- System.get_env("PROPCHECK_NUMTESTS", "100"),
         {n, ""} <- Integer.parse(s) do
      n
    else
      _ -> 100
    end
  end
end
