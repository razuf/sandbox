defmodule Sandbox.Data do
  @moduledoc """
  The Data context.
  """

  alias Sandbox.Data.Account

  # internal Api

  def list_accounts(api_token) do
    do_list_accounts(api_token)
  end

  defp do_list_accounts("test_acc_-LDWVmLQ") do
    [
      Jason.decode!(example_account_json(), keys: :atoms)
    ]
  end

  defp do_list_accounts(_not_matched_api_token) do
    []
  end

  defp account_from_json(json) do
    Jason.decode!(json, keys: :atoms)
  end

  # some example data

  def example_api_token() do
    "test_acc_-LDWVmLQ"
  end

  def example_account_json() do
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
end
