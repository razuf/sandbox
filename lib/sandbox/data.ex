defmodule Sandbox.Data do
  @moduledoc """
  The Data context.
  """

  alias Sandbox.Data.Account
  alias Sandbox.Data.Transaction

  # api_token

  def list_api_token() do
    case System.get_env("SANDBOX_API_TOKEN") do
      nil ->
        Application.fetch_env!(:sandbox, :sandbox_api_token)

      token_list ->
        token_list
        |> (String.split(":", trim: true)
            |> Kernel.++(Application.fetch_env!(:sandbox, :sandbox_api_token)))
    end
  end

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
    case find_api_token(api_token) do
      :ok ->
        Account.get_account_by_id(api_token, account_id)

      _ ->
        []
    end
  end

  # transactions

  def get_transactions_by_id(api_token, account_id) do
    case find_api_token(api_token) do
      :ok ->
        Transaction.get_transactions_by_id(api_token, account_id)

      _ ->
        []
    end
  end
end
