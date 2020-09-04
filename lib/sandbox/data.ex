defmodule Sandbox.Data do
  @moduledoc """
  The Data context.
  """

  @app Mix.Project.config()[:app]

  # testing

  def example_account_id() do
    account =
      do_list_api_tokens()
      |> List.first()
      |> list_accounts()
      |> List.first()

    account.id
  end

  def example_api_token() do
    List.first(do_list_api_tokens())
  end

  # api_token auth

  def find_api_token(api_token) do
    case Enum.find(do_list_api_tokens(), fn token -> token == api_token end) do
      nil -> :error
      _api_token -> :ok
    end
  end

  # acccounts

  def list_accounts(api_token) do
    do_list_accounts(api_token)
  end

  def get_account_by_id(api_token, account_id) do
    do_get_account_by_id(api_token, account_id)
  end

  # transactions

  def get_transactions_by_id(api_token, account_id) do
    do_get_transactions_by_id(api_token, account_id)
  end

  # some example data

  defp do_list_api_tokens() do
    [
      "test_CQBfUQMcicDV__AhXOOCSA",
      "test_FxCedFqjKlgmbtuYdw4235"
    ]
  end

  defp do_list_accounts("test_CQBfUQMcicDV__AhXOOCSA") do
    ~s([
      {
        "account_number": "8070518251",
        "balances": {
            "available": "144.98",
            "ledger": "144.98"
        },
        "currency_code": "USD",
        "enrollment_id": "test_enr_VUBAXEvu",
        "id": "test_acc_-LDWVmLQ",
        "institution": {
            "id": "first_republic",
            "name": "First Republic"
        },
        "links": {
            "self": "https://api.teller.io/accounts/test_acc_-LDWVmLQ",
            "transactions": "https://api.teller.io/accounts/test_acc_-LDWVmLQ/transactions"
        },
        "name": "Teller API Sandbox Checking",
        "routing_numbers": {
            "ach": "898564206"
        },
        "subtype": "checking",
        "type": "depository"
    }
    ])
    |> Jason.decode!(keys: :atoms)
  end

  defp do_list_accounts("test_FxCedFqjKlgmbtuYdw4235") do
    ~s([
      {
        "account_number": "5122860384",
        "balances": {
            "available": "1631.38",
            "ledger": "1631.38"
        },
        "currency_code": "USD",
        "enrollment_id": "test_enr_7aiZfKMh",
        "id": "test_acc_jumJMEtb",
        "institution": {
            "id": "wells_fargo",
            "name": "Wells Fargo"
        },
        "links": {
            "self": "https://api.teller.io/accounts/test_acc_jumJMEtb",
            "transactions": "https://api.teller.io/accounts/test_acc_jumJMEtb/transactions"
        },
        "name": "Teller API Sandbox Checking",
        "routing_numbers": {
            "ach": "615153802"
        },
        "subtype": "checking",
        "type": "depository"
    },
      {
        "account_number": "5122860385",
        "balances": {
            "available": "999999.99",
            "ledger": "999999.99"
        },
        "currency_code": "EUR",
        "enrollment_id": "test_enr_8aiZfKMh",
        "id": "test_acc_kumJMEtb",
        "institution": {
            "id": "chase",
            "name": "Chase"
        },
        "links": {
            "self": "https://api.teller.io/accounts/test_acc_kumJMEtb",
            "transactions": "https://api.teller.io/accounts/test_acc_kumJMEtb/transactions"
        },
        "name": "Teller API Sandbox Checking 2",
        "routing_numbers": {
            "ach": "615153803"
        },
        "subtype": "checking",
        "type": "depository"
    }
    ])
    |> Jason.decode!(keys: :atoms)
  end

  defp do_list_accounts(_not_matched) do
    []
  end

  # account
  def do_get_account_by_id(api_token, account_id) do
    do_list_accounts(api_token)
    |> Enum.find(fn account -> account.id == account_id end)
  end

  # transactions
  # Todo: 90 days back from today and each day one transaction

  defp do_get_transactions_by_id("test_CQBfUQMcicDV__AhXOOCSA", "test_acc_-LDWVmLQ") do
    Application.app_dir(@app, "priv/examples/example_transactions.json")
    |> File.read!()
    |> Jason.decode!(keys: :atoms)
  end

  defp do_get_transactions_by_id(
         "test_FxCedFqjKlgmbtuYdw4235" = api_token,
         "test_acc_jumJMEtb" = account_id
       ) do
    generate_transactions(account_id)
    |> Jason.decode!(keys: :atoms)
  end

  defp do_get_transactions_by_id(_not_matched) do
    []
  end

  defp generate_transactions(account_id) do
    ~s([
      {
          "account_id": "#{account_id}",
          "amount": "-18.2",
          "date": "2020-09-03",
          "description": "Papa John's",
          "id": "test_txn_WUINMxB1",
          "links": {
              "account": "https://api.teller.io/accounts/#{account_id}",
              "self": "https://api.teller.io/accounts/#{account_id}/transactions/test_txn_WUINMxB1"
          },
          "running_balance": "144.98",
          "type": "card_payment"
      },
      {
          "account_id": "#{account_id}",
          "amount": "-34.62",
          "date": "2020-09-02",
          "description": "CVS",
          "id": "test_txn_kxMoBAGs",
          "links": {
              "account": "https://api.teller.io/accounts/#{account_id}",
              "self": "https://api.teller.io/accounts/#{account_id}/transactions/test_txn_kxMoBAGs"
          },
          "running_balance": "163.18",
          "type": "card_payment"
      },
      {
          "account_id": "#{account_id}",
          "amount": "-32.79",
          "date": "2020-09-01",
          "description": "CVS",
          "id": "test_txn_4_iw1lZi",
          "links": {
              "account": "https://api.teller.io/accounts/#{account_id}",
              "self": "https://api.teller.io/accounts/#{account_id}/transactions/test_txn_4_iw1lZi"
          },
          "running_balance": "197.80",
          "type": "card_payment"
      }
    ])
  end
end
