defmodule Given.GeneratorsTest do

  use ExUnit.Case
  use PropCheck
  alias Given.Generators, as: Gen

  property "a simple forall shrinks" do
    forall d <- Gen.iso8601_date do
      _ = Date.from_iso8601!(d)
      true
    end
  end

end
