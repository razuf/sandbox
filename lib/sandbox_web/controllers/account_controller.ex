defmodule SandboxWeb.AccountController do
  use SandboxWeb, :controller

  alias Sandbox.Data

  action_fallback SandboxWeb.FallbackController

  def index(conn, _params) do
    accounts = Data.list_accounts(conn.assigns.api_token)
    render(conn, "index.json", accounts: accounts)
  end
end
