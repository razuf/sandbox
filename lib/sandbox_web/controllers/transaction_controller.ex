defmodule SandboxWeb.TransactionController do
  use SandboxWeb, :controller

  alias Sandbox.Data
  alias Sandbox.Data.Transaction

  action_fallback SandboxWeb.FallbackController

  def transactions(conn, %{"account_id" => account_id}) do
    transactions = Data.get_transactions_by_id(account_id)
    render(conn, "index.json", transactions: transactions)
  end
end
