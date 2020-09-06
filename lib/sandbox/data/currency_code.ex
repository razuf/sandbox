defmodule Sandbox.Data.CurrencyCode do
  def get(idx) do
    len = length(list())
    index = rem(idx, len)
    {value, _rest} = List.pop_at(list(), index, "USD")
    value
  end

  def list() do
    Money.known_current_currencies()
    |> Enum.map(fn currency_code -> Atom.to_string(currency_code) end)
  end
end
