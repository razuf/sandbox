defmodule Sandbox.DataTest do
  use Sandbox.DataCase

  alias Sandbox.Data
  alias Sandbox.Data.Token

  @valid_api_token "test_api_ASS3YC4C_H3WJOVFC"
  @valid_account_id "test_acc_ASSXRJKQ_H3WJOBKZ"
  @valid_account_list [
    %{
      account_number: "8079287048",
      balances: %{available: "2346101333.01", ledger: "2346101333.01"},
      currency_code: "SCR",
      enrollment_id: "test_enr_ASSXRJKQ_H3WBFSB4",
      id: "test_acc_ASSXRJKQ_H3WJOBK2",
      institution: %{id: "umweltbank", name: "Umweltbank"},
      links: %{
        self: "http://localhost:4000/accounts/test_acc_ASSXRJKQ_H3WJOBK2",
        transactions: "http://localhost:4000/accounts/test_acc_ASSXRJKQ_H3WJOBK2/transactions"
      },
      name: "Albert Einstein",
      routing_numbers: %{ach: "907333003", wire: "133721387"},
      subtype: "checking",
      type: "depository"
    },
    %{
      account_number: "8079287049",
      balances: %{available: "2346101333.01", ledger: "2346101333.01"},
      currency_code: "SDG",
      enrollment_id: "test_enr_ASSXRJKQ_H3WBFSB4",
      id: "test_acc_ASSXRJKQ_H3WJOBKZ",
      institution: %{id: "ethikbank", name: "EthikBank"},
      links: %{
        self: "http://localhost:4000/accounts/test_acc_ASSXRJKQ_H3WJOBKZ",
        transactions: "http://localhost:4000/accounts/test_acc_ASSXRJKQ_H3WJOBKZ/transactions"
      },
      name: "Werner Heisenberg",
      routing_numbers: %{ach: "907333004", wire: "133721388"},
      subtype: "checking",
      type: "depository"
    },
    %{
      account_number: "8079287050",
      balances: %{available: "2346101333.01", ledger: "2346101333.01"},
      currency_code: "SEK",
      enrollment_id: "test_enr_ASSXRJKQ_H3WBFSB4",
      id: "test_acc_ASSXRJKQ_H3WJOBKY",
      institution: %{id: "tomorrow", name: "Tomorrow"},
      links: %{
        self: "http://localhost:4000/accounts/test_acc_ASSXRJKQ_H3WJOBKY",
        transactions: "http://localhost:4000/accounts/test_acc_ASSXRJKQ_H3WJOBKY/transactions"
      },
      name: "Enrico Fermi",
      routing_numbers: %{ach: "907333005", wire: "133721389"},
      subtype: "checking",
      type: "depository"
    }
  ]
  @valid_account %{
    account_number: "8079287049",
    balances: %{available: "2346101333.01", ledger: "2346101333.01"},
    currency_code: "SDG",
    enrollment_id: "test_enr_ASSXRJKQ_H3WBFSB4",
    id: "test_acc_ASSXRJKQ_H3WJOBKZ",
    institution: %{id: "ethikbank", name: "EthikBank"},
    links: %{
      self: "http://localhost:4000/accounts/test_acc_ASSXRJKQ_H3WJOBKZ",
      transactions: "http://localhost:4000/accounts/test_acc_ASSXRJKQ_H3WJOBKZ/transactions"
    },
    name: "Werner Heisenberg",
    routing_numbers: %{ach: "907333004", wire: "133721388"},
    subtype: "checking",
    type: "depository"
  }

  @valid_transaction_first %{
    account_id: "test_acc_ASSXRJKQ_H3WJOBKZ",
    amount: "-73.23",
    date: "2020-09-14",
    description: "H.E. Butt",
    id: "test_txn_ASSXV6UD_H3WBF6D6",
    links: %{
      account: "http://localhost:4000/accounts/test_acc_ASSXRJKQ_H3WJOBKZ",
      self:
        "http://localhost:4000/accounts/test_acc_ASSXRJKQ_H3WJOBKZ/transactions/test_txn_ASSXV6UD_H3WBF6D6"
    },
    running_balance: "2346100221.18",
    type: "card_payment"
  }

  @valid_transaction_last %{
    account_id: "test_acc_ASSXRJKQ_H3WJOBKZ",
    amount: "-33.12",
    date: "2020-08-16",
    description: "Amazon",
    id: "test_txn_ASSXQUBA_H3WBF6D6",
    links: %{
      account: "http://localhost:4000/accounts/test_acc_ASSXRJKQ_H3WJOBKZ",
      self:
        "http://localhost:4000/accounts/test_acc_ASSXRJKQ_H3WJOBKZ/transactions/test_txn_ASSXQUBA_H3WBF6D6"
    },
    running_balance: "2346101299.89",
    type: "card_payment"
  }

  describe "api_token" do
    test "list_api_token/1 with env var SANDBOX_API_TOKEN" do
      System.put_env("SANDBOX_API_TOKEN", @valid_api_token)
      list = Data.list_api_token()

      assert Enum.find(list, fn token -> token == @valid_api_token end) == @valid_api_token
      System.delete_env("SANDBOX_API_TOKEN")
    end

    test "find_api_token/1 with env var SANDBOX_API_TOKEN" do
      System.put_env("SANDBOX_API_TOKEN", @valid_api_token)

      assert Data.find_api_token(@valid_api_token) == :ok
      System.delete_env("SANDBOX_API_TOKEN")
    end

    test "list_api_token/1 with env var SANDBOX_API_TOKEN randomly" do
      api_token = Token.generate_random_token("api")
      System.put_env("SANDBOX_API_TOKEN", api_token)

      list = Data.list_api_token()

      assert Enum.find(list, fn token -> token == api_token end) == api_token
      System.delete_env("SANDBOX_API_TOKEN")
    end

    test "find_api_token/1 with env var SANDBOX_API_TOKEN randomly" do
      api_token = Token.generate_random_token("api")
      System.put_env("SANDBOX_API_TOKEN", api_token)

      assert Data.find_api_token(api_token) == :ok
      System.delete_env("SANDBOX_API_TOKEN")
    end
  end

  describe "accounts" do
    test "list_accounts/1 should always return the same account data for a given api_token" do
      System.put_env("SANDBOX_API_TOKEN", @valid_api_token)

      assert Data.list_accounts(@valid_api_token) ==
               Data.list_accounts(@valid_api_token)

      System.delete_env("SANDBOX_API_TOKEN")
    end

    test "list_accounts/1 with the given api_token returns the given account list" do
      System.put_env("SANDBOX_API_TOKEN", @valid_api_token)

      assert Data.list_accounts(@valid_api_token) ==
               @valid_account_list

      System.delete_env("SANDBOX_API_TOKEN")
    end

    test "list_accounts/1 should always return the same account data for a given api_token randomly" do
      api_token = Token.generate_random_token("api")
      System.put_env("SANDBOX_API_TOKEN", api_token)

      assert Data.list_accounts(api_token) ==
               Data.list_accounts(api_token)

      System.delete_env("SANDBOX_API_TOKEN")
    end
  end

  describe "account" do
    test "get_account_by_id/2 should always return the same account for given api_token and account_id" do
      System.put_env("SANDBOX_API_TOKEN", @valid_api_token)

      assert Data.get_account_by_id(@valid_api_token, @valid_account_id) ==
               Data.get_account_by_id(@valid_api_token, @valid_account_id)

      System.delete_env("SANDBOX_API_TOKEN")
    end

    test "get_account_by_id/2 should always return the same account for given api_token and account_id randomly" do
      api_token = Token.generate_random_token("api")
      System.put_env("SANDBOX_API_TOKEN", api_token)

      account_id =
        api_token
        |> Data.list_accounts()
        |> List.first()
        |> Map.get(:id)

      assert Data.get_account_by_id(api_token, account_id) ==
               Data.get_account_by_id(api_token, account_id)

      System.delete_env("SANDBOX_API_TOKEN")
    end

    test "get_account_by_id/2 for the given api_token and account_id return the given data" do
      System.put_env("SANDBOX_API_TOKEN", @valid_api_token)

      assert Data.get_account_by_id(@valid_api_token, @valid_account_id) ==
               @valid_account

      System.delete_env("SANDBOX_API_TOKEN")
    end
  end

  describe "transactions" do
    test "get_transactions_by_id/2 should always return the same transactions for given account_id" do
      System.put_env("SANDBOX_API_TOKEN", @valid_api_token)

      assert Data.get_transactions_by_id(@valid_api_token, @valid_account_id) ==
               Data.get_transactions_by_id(@valid_api_token, @valid_account_id)

      System.delete_env("SANDBOX_API_TOKEN")
    end

    test "get_transactions_by_id/2 should always return the same transactions for given account_id randomly" do
      api_token = Token.generate_random_token("api")
      System.put_env("SANDBOX_API_TOKEN", api_token)

      account_id =
        api_token
        |> Data.list_accounts()
        |> List.first()
        |> Map.get(:id)

      assert Data.get_transactions_by_id(api_token, account_id) ==
               Data.get_transactions_by_id(api_token, account_id)

      System.delete_env("SANDBOX_API_TOKEN")
    end

    test "get_transactions_by_id/2 should return the given data" do
      System.put_env("SANDBOX_API_TOKEN", @valid_api_token)

      list = Data.get_transactions_by_id(@valid_api_token, @valid_account_id)

      assert List.first(list) ==
               @valid_transaction_first

      assert List.last(list) ==
               @valid_transaction_last

      System.delete_env("SANDBOX_API_TOKEN")
    end
  end
end
