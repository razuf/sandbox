defmodule SandboxWeb.TransactionControllerTest do
  use SandboxWeb.ConnCase

  alias Sandbox.Data

  @invalid_api_token "wrong_api_token"
  # @invalid_account_id "wrong_account_id"

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get transactions with account_id" do
    test "renders all transactions when api_token and account_id are valid", %{conn: conn} do
      for api_token <- Data.list_api_token() do
        conn =
          conn
          |> using_basic_auth(api_token)

        transactions =
          Data.get_transactions_by_id(api_token, Data.example_first_account_id(api_token))

        conn =
          get(
            conn,
            Routes.transaction_path(conn, :transactions, Data.example_first_account_id(api_token))
          )

        result =
          response(conn, 200)
          |> Jason.decode!(keys: :atoms)

        assert result.data == transactions
      end
    end

    test "error when api_token is invalid", %{conn: conn} do
      conn =
        conn
        |> using_basic_auth(@invalid_api_token)

      response =
        get(conn, Routes.transaction_path(conn, :transactions, Data.example_account_id()))

      assert response.status == 401
    end

    # Todo: error when account_id is invalid

    test "error when no basic auth with api_token", %{conn: conn} do
      response =
        get(conn, Routes.transaction_path(conn, :transactions, Data.example_account_id()))

      assert response.status == 401
    end
  end
end
