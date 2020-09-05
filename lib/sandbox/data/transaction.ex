defmodule Sandbox.Data.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sandbox.Data.TransactionLinks
  alias Sandbox.Data.TransactionAmount
  alias Sandbox.Data.Merchants
  alias Sandbox.Data.Token

  @number_of_days_for_tx_feed 90
  @app Mix.Project.config()[:app]

  @primary_key false

  embedded_schema do
    field(:account_id, :string)
    field(:amount, :string)
    field(:date, :string)
    field(:description, :string)
    field(:id, :string)
    field(:running_balance, :string)
    field(:type, :string)

    embeds_one(:links, TransactionLinks)
  end

  def changeset(params \\ %{}) do
    changeset(%__MODULE__{}, params)
  end

  def changeset(model, params) do
    fields = __MODULE__.__schema__(:fields)
    embeds = __MODULE__.__schema__(:embeds)
    cast_model = cast(model, params, fields -- embeds)

    Enum.reduce(embeds, cast_model, fn embed, model ->
      cast_embed(model, embed)
    end)
  end

  ###
  def get_transactions_by_id(api_token, account_id) do
    do_get_transactions_by_id(api_token, account_id)
  end

  defp do_get_transactions_by_id(
         "test_api_Mjqtblo=_PuwSHHY=_LSG8Vcg=",
         account_id
       ) do
    generate_list_of_txs(account_id)
  end

  # compare with original teller API
  defp do_get_transactions_by_id("test_CQBfUQMcicDV__AhXOOCSA", "test_acc_-LDWVmLQ") do
    Application.app_dir(@app, "priv/examples/example_transactions.json")
    |> File.read!()
    |> Jason.decode!(keys: :atoms)
  end

  defp do_get_transactions_by_id(_api_token, _not_matched) do
    []
  end

  ###

  def generate_list_of_txs(account_id) do
    case Token.decrypt_token(account_id) do
      {"acc", start_balance, amount_offset, description_offset} ->
        generate_tx_per_day(
          [],
          Date.add(Date.utc_today(), -@number_of_days_for_tx_feed + 1),
          -@number_of_days_for_tx_feed,
          start_balance,
          amount_offset,
          description_offset,
          account_id
        )

      _ ->
        []
    end
  end

  defp generate_tx_per_day(
         acc,
         _day,
         0,
         _start_balance,
         _amount_offset,
         _description_offset,
         _account_id
       ) do
    acc
  end

  defp generate_tx_per_day(acc, day, idx, balance, amount_offset, description_offset, account_id) do
    date = Kernel.to_string(day)
    amount = get_amount_from_list(idx + String.to_integer(amount_offset))
    description = get_description(idx + String.to_integer(description_offset))
    running_balance = Apa.add(balance, amount)
    id = gen_tx_id(running_balance)
    links = gen_links(account_id, id)

    tx =
      %{}
      |> changeset()
      |> put_change(:account_id, account_id)
      |> put_change(:type, "card_payment")
      |> put_change(:date, date)
      |> put_change(:id, id)
      |> put_change(:amount, amount)
      |> put_change(:description, description)
      |> put_change(:running_balance, running_balance)
      |> put_embed(:links, links)
      |> apply_changes()
      |> Map.from_struct()
      |> deep_map_from_struct(:links)

    generate_tx_per_day(
      [tx | acc],
      Date.add(Date.utc_today(), idx + 2),
      idx + 1,
      Apa.add(balance, amount),
      amount_offset,
      description_offset,
      account_id
    )
  end

  defp deep_map_from_struct(map, key) do
    links = Map.get(map, key)
    Map.put(map, :links, Map.from_struct(links))
  end

  def get_amount_from_list(idx) do
    TransactionAmount.get(idx)
  end

  def gen_tx_id(running_balance) do
    Token.generate_token({"txn", running_balance, "12345", "67890"})
  end

  def get_description(idx) do
    Merchants.get(idx)
  end

  def gen_links(account_id, tx_id) do
    %{
      account: "https://api.teller.io/accounts/#{account_id}",
      self: "https://api.teller.io/accounts/#{account_id}/transactions/#{tx_id}"
    }
  end
end
