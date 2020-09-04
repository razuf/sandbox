defmodule SandboxWeb.AccountController do
  use SandboxWeb, :controller

  alias Sandbox.Data

  action_fallback SandboxWeb.FallbackController

  def index(conn, _params) do
    case Data.list_accounts(conn.assigns.api_token) do
      [] -> {:error, :not_found}
      nil -> {:error, :not_found}
      accounts -> render(conn, "index.json", accounts: accounts)
    end
  end

  def show(conn, %{"account_id" => account_id}) do
    case Data.get_account_by_id(conn.assigns.api_token, account_id) do
      [] -> {:error, :not_found}
      nil -> {:error, :not_found}
      account -> render(conn, "show.json", account: account)
    end
  end
end
