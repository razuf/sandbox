defmodule Sandbox.Data.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field(:account_number, :string)
    # field(:balances, :string)
    field(:currency_code, :string)
    field(:enrollment_id, :string)
    field(:id, :string)
    # field(:institution, :string)
    # field(:links, :string)
    field(:name, :string)
    # field(:routing_numbers, :string)
    field(:subtype, :string)
    field(:type, :string)
  end
end
