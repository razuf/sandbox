defmodule Sandbox.Data do
  @moduledoc """
  The Data context.
  """

  alias Sandbox.Data.Account
  alias Sandbox.Data.Transaction

  # for tests

  def example_api_token() do
    List.first(list_api_token())
  end

  def example_account_id() do
    list_api_token()
    |> List.first()
    |> example_first_account_id()
  end

  def example_first_account_id(api_token) do
    api_token
    |> list_accounts()
    |> List.first()
    |> Map.get(:id)
  end

  # api_token auth

  def find_api_token(api_token) do
    case Enum.find(list_api_token(), fn token -> token == api_token end) do
      nil -> :error
      _api_token -> :ok
    end
  end

  # acccounts

  def list_accounts(api_token) do
    Account.list_accounts(api_token)
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
      "test_CQBfUQMcicDV__AhXOOCSA",
      "test_api_Mjqtblo=_PuwSHHY=_LSG8Vcg="
    ]
  end
end
