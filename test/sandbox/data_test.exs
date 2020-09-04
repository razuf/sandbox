defmodule Sandbox.DataTest do
  use Sandbox.DataCase

  alias Sandbox.Data

  describe "accounts" do
    test "list_accounts/1 returns all accounts for given api_token" do
      assert Data.list_accounts(Data.example_api_token()) ==
               Data.list_accounts(Data.example_api_token())
    end
  end

  describe "account" do
    test "get_account_by_id/2 returns the account for given api_token and account_id" do
      assert Data.get_account_by_id(Data.example_api_token(), Data.example_account_id()) ==
               Data.get_account_by_id(Data.example_api_token(), Data.example_account_id())
    end
  end

  describe "transactions" do
    test "get_transactions_by_id/2 returns all transactions for given account_id" do
      assert Data.get_transactions_by_id(Data.example_api_token(), Data.example_account_id()) ==
               Data.get_transactions_by_id(Data.example_api_token(), Data.example_account_id())
    end
  end
end
