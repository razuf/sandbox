defmodule SandboxWeb.TokenControllerTest do
  use SandboxWeb.ConnCase

  alias Sandbox.Data.Token

  @balance "435875784578.12"
  @offset 34
  @valid_api_token "test_api_ASS3YC4C_H3WJOVFC"

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get token" do
    test "renders a new token", %{conn: conn} do
      api_token = Token.generate_token({"api", @balance, @offset})

      conn = get(conn, Routes.token_path(conn, :create), balance: @balance, offset: @offset)

      result =
        response(conn, 200)
        |> Jason.decode!(keys: :atoms)

      assert result.token == api_token
    end

    test "renders a new token with ENV", %{conn: conn} do
      System.put_env("SANDBOX_API_TOKEN", @valid_api_token)

      api_token = Token.generate_token({"api", @balance, @offset})

      conn = get(conn, Routes.token_path(conn, :create), balance: @balance, offset: @offset)

      result =
        response(conn, 200)
        |> Jason.decode!(keys: :atoms)

      assert result.token == api_token
      System.delete_env("SANDBOX_API_TOKEN")
    end

    test "error when api_token is valid and account_id is invalid", %{conn: conn} do
      conn = get(conn, Routes.token_path(conn, :create))

      assert conn.status == 404
    end
  end
end
