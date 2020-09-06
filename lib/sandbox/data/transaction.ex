defmodule Sandbox.Data.Transaction do
  alias Sandbox.Data.TransactionAmount
  alias Sandbox.Data.Merchants
  alias Sandbox.Data.Token

  @number_of_days_for_tx_feed 90
  # @app Mix.Project.config()[:app]

  def get_transactions_by_id(api_token, account_id) do
    do_get_transactions_by_id(api_token, account_id)
  end

  defp do_get_transactions_by_id(
         "test_api_Mjqtblo=_PuwSHHY=",
         account_id
       ) do
    generate_list_of_txs(account_id)
  end

  # compare with original teller API
  # defp do_get_transactions_by_id("test_CQBfUQMcicDV__AhXOOCSA", "test_acc_-LDWVmLQ") do
  #   Application.app_dir(@app, "priv/examples/example_transactions.json")
  #   |> File.read!()
  #   |> Jason.decode!(keys: :atoms)
  # end

  defp do_get_transactions_by_id(_api_token, _not_matched) do
    []
  end

  ###

  def generate_list_of_txs(account_id) do
    case Token.decrypt_token(account_id) do
      {"acc", start_balance, offset} ->
        generate_tx_per_day(
          [],
          Date.add(Date.utc_today(), -@number_of_days_for_tx_feed + 1),
          -@number_of_days_for_tx_feed,
          start_balance,
          offset,
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
         _offset,
         _account_id
       ) do
    acc
  end

  defp generate_tx_per_day(acc, day, idx, balance, offset, account_id) do
    date = Kernel.to_string(day)
    amount = TransactionAmount.get(idx + offset)
    description = Merchants.get(idx + offset)
    running_balance = Apa.add(balance, amount)
    id = Token.generate_token({"txn", running_balance, 12345})
    links = gen_links(account_id, id)

    tx = %{
      account_id: account_id,
      type: "card_payment",
      date: date,
      id: id,
      amount: amount,
      description: description,
      running_balance: running_balance,
      links: links
    }

    generate_tx_per_day(
      [tx | acc],
      Date.add(Date.utc_today(), idx + 2),
      idx + 1,
      Apa.add(balance, amount),
      offset,
      account_id
    )
  end

  def gen_links(account_id, tx_id) do
    %{
      account: "https://api.teller.io/accounts/#{account_id}",
      self: "https://api.teller.io/accounts/#{account_id}/transactions/#{tx_id}"
    }
  end
end
