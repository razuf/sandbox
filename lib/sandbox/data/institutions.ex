defmodule Sandbox.Data.Institutions do
  def get(idx) do
    len = length(list())
    index = rem(idx, len)
    {value, _rest} = List.pop_at(list(), index, "Citi")
    value
  end

  def list() do
    [
      "Chase",
      "Bank of America",
      "Wells Fargo",
      "Citi",
      "Capital One"
    ]
  end
end
