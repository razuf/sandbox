defmodule Sandbox.Data do
  @moduledoc """
  The Data context.
  """

  alias Sandbox.Data.Account
  alias Sandbox.Data.Transaction

  # api_token auth

  def find_api_token(api_token) do
    case Enum.find(list_api_token(), fn token -> token == api_token end) do
      nil -> :error
      _api_token -> :ok
    end
  end

  # acccounts

  def list_accounts(api_token) do
    case find_api_token(api_token) do
      :ok -> Account.list_accounts(api_token)
      _ -> []
    end
  end

  def get_account_by_id(api_token, account_id) do
    Account.get_account_by_id(api_token, account_id)
  end

  # transactions

  def get_transactions_by_id(api_token, account_id) do
    Transaction.get_transactions_by_id(api_token, account_id)
  end

  # data

  def list_api_token() do
    [
      # compare with original teller API
      # "test_CQBfUQMcicDV__AhXOOCSA",
      "test_api_Mjqtblo=_PuwSHHY=",
      "test_api_K-QfLaI=_PHpU0YA="
    ]
  end
end
