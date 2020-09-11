defmodule Sandbox.Data.Transaction do
  alias Sandbox.Data.TransactionAmount
  alias Sandbox.Data.Merchants
  alias Sandbox.Data.Token

  @number_of_days_for_tx_feed 90

  def get_transactions_by_id(_api_token, account_id) do
    generate_list_of_txs(account_id)
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
      account: "http://localhost:4000/accounts/#{account_id}",
      self: "http://localhost:4000/accounts/#{account_id}/transactions/#{tx_id}"
    }
  end
end
