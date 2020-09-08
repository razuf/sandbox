defmodule SandboxWeb.AccountView do
  use SandboxWeb, :view
  alias SandboxWeb.AccountView

  def render("index.json", %{accounts: accounts}) do
    render_many(accounts, AccountView, "account.json")
  end

  def render("show.json", %{account: account}) do
    render_one(account, AccountView, "account.json")
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      account_number: account.account_number,
      name: account.name,
      currency_code: account.currency_code,
      enrollment_id: account.enrollment_id,
      id: account.id,
      subtype: account.subtype,
      type: account.type,
      balances: account.balances,
      institution: account.institution,
      links: account.links,
      routing_numbers: account.routing_numbers
    }
  end
end
