defmodule SandboxWeb.AccountControllerTest do
  use SandboxWeb.ConnCase

  alias Sandbox.Data

  @invalid_api_token "wrong_api_token"
  @app Mix.Project.config()[:app]

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all accounts for given valid api_token", %{conn: conn} do
      conn =
        conn
        |> using_basic_auth(Data.example_api_token())

      accounts = Data.list_accounts(Data.example_api_token())

      conn = get(conn, Routes.account_path(conn, :index))

      result =
        response(conn, 200)
        |> Jason.decode!(keys: :atoms)

      assert result.data == accounts
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

  describe "compare with original Teller API" do
    test "compare accounts for given api_token", %{conn: conn} do
      file_path = Application.app_dir(@app, "priv/examples/example_accounts.json")
      {:ok, file_content} = File.read(file_path)
      {:ok, teller_accounts} = Jason.decode(file_content, keys: :atoms)

      conn =
        conn
        |> using_basic_auth("test_CQBfUQMcicDV__AhXOOCSA")

      conn = get(conn, Routes.account_path(conn, :index))

      result =
        response(conn, 200)
        |> Jason.decode!(keys: :atoms)

      assert result.data == teller_accounts
    end
  end
end
