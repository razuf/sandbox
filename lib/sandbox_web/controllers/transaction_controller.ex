defmodule SandboxWeb.TransactionController do
  use SandboxWeb, :controller

  alias Sandbox.Data

  action_fallback SandboxWeb.FallbackController

  def transactions(conn, %{"account_id" => account_id}) do
    case Data.get_transactions_by_id(conn.assigns.api_token, account_id) do
      [] -> {:error, :not_found}
      nil -> {:error, :not_found}
      transactions -> render(conn, "index.json", transactions: transactions)
    end
  end
end
