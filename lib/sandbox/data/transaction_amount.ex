defmodule Sandbox.Data.TransactionAmount do
  def get(idx) do
    len = length(list())
    index = rem(idx, len)
    {value, _rest} = List.pop_at(list(), index, "33.12")
    value
  end

  def list() do
    [
      "-33.12",
      "-18.20",
      "-45.00",
      "-11.33",
      "-36.99",
      "-6.95",
      "-42.05",
      "-33.33",
      "-66.66",
      "-11.99",
      "-21.35",
      "-43.66",
      "-89.74",
      "-73.23",
      "-16.98",
      "-27.65"
    ]
  end
end
