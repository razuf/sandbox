defmodule Sandbox.DataTest do
  use Sandbox.DataCase

  alias Sandbox.Data

  describe "accounts" do
    alias Sandbox.Data.Account

    test "list_accounts/1 returns all accounts for given token" do
      account =
        Data.get_accounts_by_id(Data.example_api_token())
        |> Jason.decode!(keys: :atoms)

      assert Data.list_accounts(Data.example_api_token()) == [account]
    end
  end

  describe "transactions" do
    alias Sandbox.Data.Transaction

    test "get_transactions_by_id/1 returns all transactions for given account_id" do
      # must be always the same ;-)
      assert Data.get_transactions_by_id(Data.example_api_token()) ==
               Data.get_transactions_by_id(Data.example_api_token())
    end
  end
end
