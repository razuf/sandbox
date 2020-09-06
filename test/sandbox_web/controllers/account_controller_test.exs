defmodule SandboxWeb.AccountControllerTest do
  use SandboxWeb.ConnCase

  alias Sandbox.Data

  @valid_api_token List.first(Data.list_api_token())
  @invalid_api_token "wrong_api_token"
  @valid_account_id "test_acc_Mjqtblo=_PuwSyEY="
  @another_account_id "test_acc_K-QfLaI=_JzKvyYA="

  # @original_teller_api_account "test_CQBfUQMcicDV__AhXOOCSA"
  # @app Mix.Project.config()[:app]

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "accounts index" do
    test "lists all accounts for given valid api_token", %{conn: conn} do
      Data.list_api_token()
      |> Enum.each(fn api_token ->
        conn =
          conn
          |> using_basic_auth(api_token)

        accounts = Data.list_accounts(api_token)

        conn = get(conn, Routes.account_path(conn, :index))

        result =
          response(conn, 200)
          |> Jason.decode!(keys: :atoms)

        assert result.data == accounts
      end)
    end

    test "error when api_token is invalid", %{conn: conn} do
      conn =
        conn
        |> using_basic_auth(@invalid_api_token)

      response = get(conn, Routes.account_path(conn, :index))
      assert response.status == 401
    end

    test "error when no basic auth with api_token", %{conn: conn} do
      response = get(conn, Routes.account_path(conn, :index))
      assert response.status == 401
    end
  end

  describe "accounts show" do
    test "render account for all valid account_ids", %{conn: conn} do
      Data.list_api_token()
      |> Enum.map(fn token ->
        Enum.map(Data.list_accounts(token), fn account ->
          {token, account.id}
        end)
      end)
      |> List.flatten()
      |> Enum.each(fn tuple -> test_api_token_with_account_id(tuple, conn) end)
    end

    defp test_api_token_with_account_id({api_token, account_id}, conn) do
      conn =
        conn
        |> using_basic_auth(api_token)

      account = Data.get_account_by_id(api_token, account_id)

      conn = get(conn, Routes.account_path(conn, :show, account_id))

      result =
        response(conn, 200)
        |> Jason.decode!(keys: :atoms)

      assert result.data == account
    end

    test "error when api_token is invalid", %{conn: conn} do
      conn =
        conn
        |> using_basic_auth(@invalid_api_token)

      response = get(conn, Routes.account_path(conn, :show, @valid_account_id))

      assert response.status == 401
    end

    test "error when api_token is valid but an account_id from another api_token", %{conn: conn} do
      conn =
        conn
        |> using_basic_auth(@valid_api_token)

      response = get(conn, Routes.account_path(conn, :show, @another_account_id))

      assert response.status == 404
    end

    test "error when no basic auth with api_token", %{conn: conn} do
      response = get(conn, Routes.account_path(conn, :show, @valid_account_id))

      assert response.status == 401
    end
  end

  # describe "compare with original Teller API" do
  #   test "compare accounts for given api_token", %{conn: conn} do
  #     file_path = Application.app_dir(@app, "priv/examples/example_accounts.json")
  #     {:ok, file_content} = File.read(file_path)
  #     {:ok, teller_accounts} = Jason.decode(file_content, keys: :atoms)

  #     conn =
  #       conn
  #       |> using_basic_auth(@original_teller_api_account)

  #     conn = get(conn, Routes.account_path(conn, :index))

  #     result =
  #       response(conn, 200)
  #       |> Jason.decode!(keys: :atoms)

  #     assert result.data == teller_accounts
  #   end
  # end
end
