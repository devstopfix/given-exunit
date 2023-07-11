defmodule Given.GeneratorsTest do
  use ExUnit.Case
  use PropCheck
  alias Given.Generators, as: Gen

  property "ISO 8601 dates" do
    forall d <- Gen.iso8601_date() do
      _ = Date.from_iso8601!(d)
      true
    end
  end

  property "ISO 8601 times" do
    forall d <- Gen.iso8601_time() do
      _ = Time.from_iso8601!(d)
      true
    end
  end
end
