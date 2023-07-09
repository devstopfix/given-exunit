defmodule Given.Generators do
  use PropCheck

  def given, do: "Given" |> cases() |> elements()
  def when_, do: "When" |> cases() |> elements()
  def then_, do: "Then" |> cases() |> elements()
  def and_, do: "And" |> cases() |> elements()

  def term, do: elements([integer(), iso8601_date()])

  def iso8601_date do
    let {y, {m, d}} <- {year(), month_day()} do
      "~4..0b-~2..0b-~2..0b"
      |> :io_lib.format([y, m, d])
      |> to_string()
    end
  end

  defp year, do: integer(1900, 2030)

  defp month_day, do: elements([month_28(), month_30(), month_31()])

  defp month_28 do
    let d <- integer(1, 28) do
      {exactly(2), d}
    end
  end

  defp month_30 do
    let {m, d} <- {elements([4, 6, 9, 11]), integer(1, 30)} do
      {m, d}
    end
  end

  defp month_31 do
    let {m, d} <- {elements([1, 3, 5, 7, 8, 10, 12]), integer(1, 31)} do
      {m, d}
    end
  end

  defp cases(s), do: [s, String.upcase(s)]
end
