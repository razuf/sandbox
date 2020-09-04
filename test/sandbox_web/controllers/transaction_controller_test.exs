defmodule SandboxWeb.TransactionControllerTest do
  use SandboxWeb.ConnCase

  alias Sandbox.Data

  @invalid_api_token "wrong_api_token"
  @invalid_account_id "wrong_account_id"

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get transactions with account_id" do
    test "renders all transactions when api_token and account_id are valid", %{conn: conn} do
      conn =
        conn
        |> using_basic_auth(Data.example_api_token())

      transactions =
        Data.get_transactions_by_id(Data.example_api_token(), Data.example_account_id())

      conn = get(conn, Routes.transaction_path(conn, :transactions, Data.example_account_id()))

      result =
        response(conn, 200)
        |> Jason.decode!(keys: :atoms)

      assert result.data == transactions
    end

    test "error when api_token is invalid", %{conn: conn} do
      conn =
        conn
        |> using_basic_auth(@invalid_api_token)

      response =
        get(conn, Routes.transaction_path(conn, :transactions, Data.example_account_id()))

      assert response.status == 401
    end

    test "error when no basic auth with api_token", %{conn: conn} do
      response =
        get(conn, Routes.transaction_path(conn, :transactions, Data.example_account_id()))

      assert response.status == 401
    end
  end
end
