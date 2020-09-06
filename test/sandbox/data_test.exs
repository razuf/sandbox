defmodule Sandbox.DataTest do
  use Sandbox.DataCase

  alias Sandbox.Data
  alias Sandbox.Data.Token

  describe "accounts" do
    test "list_accounts/1 should always return the same data for a given api_token" do
      assert Data.list_accounts(example_api_token()) ==
               Data.list_accounts(example_api_token())
    end
  end

  describe "account" do
    test "get_account_by_id/2 should always return the same account for given api_token and account_id" do
      assert Data.get_account_by_id(example_api_token(), example_account_id()) ==
               Data.get_account_by_id(example_api_token(), example_account_id())
    end
  end

  describe "transactions" do
    test "get_transactions_by_id/2 should always return the same transactions for given account_id" do
      assert Data.get_transactions_by_id(example_api_token(), example_account_id()) ==
               Data.get_transactions_by_id(example_api_token(), example_account_id())
    end
  end

  describe "token" do
    test "encrypt and decrypt token" do
      params = {"acc", "666666666.00", 321}
      token = Token.generate_token(params)
      decrypted = Token.decrypt_token(token)

      assert decrypted == params
    end

    test "error encrypt token" do
      wrong_params = {"acc", "-666666666.00", 321}

      assert_raise ArgumentError, fn -> Token.generate_token(wrong_params) end
    end
  end

  defp example_api_token() do
    List.first(Data.list_api_token())
  end

  defp example_account_id() do
    Data.list_api_token()
    |> List.first()
    |> example_first_account_id()
  end

  defp example_first_account_id(api_token) do
    api_token
    |> Data.list_accounts()
    |> List.first()
    |> Map.get(:id)
  end
end
