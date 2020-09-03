defmodule Sandbox.Data do
  @moduledoc """
  The Data context.
  """

  alias Sandbox.Data.Account

  # internal Api

  def find_api_token(api_token) do
    case Enum.find(do_list_api_tokens(), fn token -> token == api_token end) do
      nil -> :error
      _api_token -> :ok
    end
  end

  def list_accounts(api_token) do
    do_list_accounts(api_token)
  end

  def get_accounts_by_id(api_token) do
    do_get_accounts_by_id(api_token)
  end

  def example_api_token() do
    List.first(do_list_api_tokens())
  end

  defp do_list_accounts(api_token) do
    [
      Jason.decode!(do_get_accounts_by_id(api_token), keys: :atoms)
    ]
  end

  defp account_from_json(json) do
    Jason.decode!(json, keys: :atoms)
  end

  # some example data

  defp do_list_api_tokens() do
    [
      "test_acc_-LDWVmLQ",
      "test_acc_jumJMEtb"
    ]
  end

  defp do_get_accounts_by_id("test_acc_-LDWVmLQ") do
    ~s(
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
  )
  end

  defp do_get_accounts_by_id("test_acc_jumJMEtb") do
    ~s(
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
    }
    )
  end

  defp do_get_accounts_by_id(_not_matched) do
    nil
  end
end
