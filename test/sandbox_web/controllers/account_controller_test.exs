defmodule SandboxWeb.AccountControllerTest do
  use SandboxWeb.ConnCase

  alias Sandbox.Data

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all accounts for given api_token", %{conn: conn} do
      accounts = Data.list_accounts(Data.example_api_token())

      conn = get(conn, Routes.account_path(conn, :index))

      result =
        response(conn, 200)
        |> Jason.decode!(keys: :atoms)

      IO.inspect(binding(), label: "### binding")

      assert result.data == accounts
    end
  end
end
