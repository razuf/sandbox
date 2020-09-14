defmodule Sandbox.Data.Institutions do
  def get(idx) do
    len = length(list())
    index = rem(idx, len)
    {value, _rest} = List.pop_at(list(), index, "Citi")
    value
  end

  def list() do
    [
      "GLS Bank",
      "Triodos Bank",
      "KD-Bank",
      "Steyler Ethik Bank",
      "Oikocredit",
      "Umweltbank",
      "EthikBank",
      "Tomorrow"
    ]
  end
end
