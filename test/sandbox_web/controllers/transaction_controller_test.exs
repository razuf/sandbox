defmodule SandboxWeb.TransactionControllerTest do
  use SandboxWeb.ConnCase

  alias Sandbox.Data

  @valid_api_token List.first(Data.list_api_token())
  @invalid_api_token "wrong_api_token"
  @valid_account_id "test_acc_Mjqtblo=_PuwSyEY="
  @invalid_account_id "wrong_account_id"

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get transactions with account_id" do
    test "renders all transactions when api_token and account_id are valid", %{conn: conn} do
      Data.list_api_token()
      |> Enum.map(fn token ->
        Enum.map(Data.list_accounts(token), fn account -> {token, account.id} end)
      end)
      |> List.flatten()
      |> Enum.each(fn tuple -> test_api_token_with_account_id(tuple, conn) end)
    end

    defp test_api_token_with_account_id({api_token, account_id}, conn) do
      conn =
        conn
        |> using_basic_auth(api_token)

      transactions = Data.get_transactions_by_id(api_token, account_id)

      conn =
        get(
          conn,
          Routes.transaction_path(conn, :transactions, account_id)
        )

      case transactions do
        [] ->
          assert conn.status == 404

        _ ->
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
        get(
          conn,
          Routes.transaction_path(
            conn,
            :transactions,
            @valid_account_id
          )
        )

      assert response.status == 401
    end

    test "error when api_token is valid and account_id is invalid", %{conn: conn} do
      conn =
        conn
        |> using_basic_auth(@valid_api_token)

      response =
        get(
          conn,
          Routes.transaction_path(
            conn,
            :transactions,
            @invalid_account_id
          )
        )

      assert response.status == 404
    end

    test "error when no basic auth with api_token", %{conn: conn} do
      response =
        get(
          conn,
          Routes.transaction_path(
            conn,
            :transactions,
            @valid_account_id
          )
        )

      assert response.status == 401
    end
  end
end
