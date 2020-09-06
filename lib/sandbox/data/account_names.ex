defmodule Sandbox.Data.AccountNames do
  def get(idx) do
    len = length(list())
    index = rem(idx, len)
    {value, _rest} = List.pop_at(list(), index, "Barack Obama")
    value
  end

  def list() do
    [
      "Jimmy Carter",
      "Ronald Reagan",
      "George H. W. Bush",
      "Bill Clinton",
      "George W. Bush",
      "Barack Obama",
      "Donald Trump"
    ]
  end
end
