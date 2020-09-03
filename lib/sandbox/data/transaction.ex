defmodule Sandbox.Data.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "transactions" do
    field(:account_id, :string)
    field(:amount, :string)
    field(:date, :string)
    field(:description, :string)
    field(:id, :string)
    # field(:links, :string)
    field(:running_balance, :string)
    field(:type, :string)
  end
end
