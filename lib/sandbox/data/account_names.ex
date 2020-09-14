defmodule Sandbox.Data.AccountNames do
  def get(idx) do
    len = length(list())
    index = rem(idx, len)
    {value, _rest} = List.pop_at(list(), index, "Barack Obama")
    value
  end

  def list() do
    [
      "Aristoteles",
      "Archimedes",
      "Nikolaus Kopernikus",
      "Galileo Galilei",
      "Isaac Newton",
      "Daniel Bernoulli",
      "Leonhard Euler",
      "Heinrich Hertz",
      "Max Planck",
      "Marie Curie",
      "Albert Einstein",
      "Werner Heisenberg",
      "Enrico Fermi",
      "John Archibald Wheeler",
      "Richard Feynman",
      "Chen Ning Yang",
      "Stephen Hawking"
    ]
  end
end
