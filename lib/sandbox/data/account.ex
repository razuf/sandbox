defmodule Sandbox.Data.Account do
  alias Sandbox.Data.Institutions
  alias Sandbox.Data.AccountNames
  alias Sandbox.Data.CurrencyCode
  alias Sandbox.Data.Token
  alias Apa

  def get_account_by_id(api_token, account_id) do
    list_accounts(api_token)
    |> Enum.find(fn account -> account.id == account_id end)
  end

  def list_accounts(api_token) do
    generate_list_of_accounts(api_token)
  end

  defp generate_list_of_accounts(api_token) do
    case Token.decrypt_token(api_token) do
      {"api", balance, offset} ->
        for i <- 0..rem(offset, 3) do
          generate_account(Apa.add(balance, "123456.78"), offset + 12344 + i)
        end

      _ ->
        []
    end
  end

  defp generate_account(balance, offset) do
    account_number = gen_account_number(offset)
    currency_code = CurrencyCode.get(offset)
    enrollment_id = Token.generate_token({"enr", balance, 123})
    account_id = Token.generate_token({"acc", balance, offset})
    institution = gen_institution(offset)
    links = gen_links(account_id)
    name = AccountNames.get(offset)
    routing_numbers_ach = gen_routing_numbers_ach(offset)
    routing_numbers_wire = gen_routing_numbers_wire(offset)

    %{
      account_number: account_number,
      balances: %{
        available: balance,
        ledger: balance
      },
      currency_code: currency_code,
      enrollment_id: enrollment_id,
      id: account_id,
      institution: institution,
      links: links,
      name: name,
      routing_numbers: %{
        ach: routing_numbers_ach,
        wire: routing_numbers_wire
      },
      subtype: "checking",
      type: "depository"
    }
  end

  defp gen_account_number(offset) do
    "8070518251"
    |> Apa.add(offset)
  end

  defp gen_institution(offset) do
    name = Institutions.get(offset)

    id =
      name
      |> String.downcase()
      |> String.replace(" ", "_")

    %{
      id: id,
      name: name
    }
  end

  defp gen_links(account_id) do
    sandbox_api_url = Application.fetch_env!(:sandbox, :sandbox_api_url)

    %{
      self: sandbox_api_url <> "/accounts/#{account_id}",
      transactions: sandbox_api_url <> "/accounts/#{account_id}/transactions"
    }
  end

  defp gen_routing_numbers_ach(offset) do
    "898564206"
    |> Apa.add(offset)
  end

  defp gen_routing_numbers_wire(offset) do
    "124952590"
    |> Apa.add(offset)
  end
end
