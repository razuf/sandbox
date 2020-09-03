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
end
