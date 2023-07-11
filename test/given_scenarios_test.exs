defmodule Given.ScenariosTest do
  use ExUnit.Case
  use PropCheck

  import Given.Generators, only: [scenario: 0]
  import Given.Parser, only: [parse: 1]

  property "Parse scenario" do
    forall scenario <- scenario() do
      # IO.puts(scenario)
      {:ok, _} = parse(scenario)
      true
    end
  end
end
