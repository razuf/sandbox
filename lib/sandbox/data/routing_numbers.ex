defmodule Sandbox.Data.RoutingNumbers do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field(:ach, :string)
    field(:wire, :string)
  end

  def changeset(params \\ %{}) do
    changeset(%__MODULE__{}, params)
  end

  def changeset(model, params) do
    fields = __MODULE__.__schema__(:fields)
    cast(model, params, fields)
  end
end
