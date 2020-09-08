defmodule SandboxWeb.TransactionView do
  use SandboxWeb, :view
  alias SandboxWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    render_many(transactions, TransactionView, "transaction.json")
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      type: transaction.type,
      running_balance: transaction.running_balance,
      id: transaction.id,
      description: transaction.description,
      date: transaction.date,
      amount: transaction.amount,
      account_id: transaction.account_id,
      links: transaction.links
    }
  end
end
