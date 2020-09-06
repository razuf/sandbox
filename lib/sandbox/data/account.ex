defmodule Sandbox.Data.Account do
  alias Sandbox.Data.Institutions
  alias Sandbox.Data.AccountNames
  alias Sandbox.Data.CurrencyCode
  alias Sandbox.Data.Token

  # @app Mix.Project.config()[:app]

  def get_account_by_id(api_token, account_id) do
    do_list_accounts(api_token)
    |> Enum.find(fn account -> account.id == account_id end)
  end

  def list_accounts(api_token) do
    do_list_accounts(api_token)
  end

  # compare with orig teller Api
  # defp do_list_accounts("test_CQBfUQMcicDV__AhXOOCSA") do
  #   Application.app_dir(@app, "priv/examples/example_accounts.json")
  #   |> File.read!()
  #   |> Jason.decode!(keys: :atoms)
  # end

  # defp do_list_accounts("test_api_Mjqtblo=_PuwSHHY=") do
  #   ~s([
  #     {
  #       "account_number": "5122860384",
  #       "balances": {
  #           "available": "999999.00",
  #           "ledger": "999999.00"
  #       },
  #       "currency_code": "USD",
  #       "enrollment_id": "test_enr_7aiZfKMh",
  #       "id": "test_acc_Mjqtblo=_PuwSyEY=",
  #       "institution": {
  #           "id": "wells_fargo",
  #           "name": "Wells Fargo"
  #       },
  #       "links": {
  #           "self": "https://api.teller.io/accounts/test_acc_Mjqtblo=_PuwSyEY=",
  #           "transactions": "https://api.teller.io/accounts/test_acc_Mjqtblo=_PuwSyEY=/transactions"
  #       },
  #       "name": "Teller API Sandbox Checking",
  #       "routing_numbers": {
  #           "ach": "615153802"
  #       },
  #       "subtype": "checking",
  #       "type": "depository"
  #   },
  #     {
  #       "account_number": "1234567890",
  #       "balances": {
  #           "available": "111111111111.00",
  #           "ledger": "111111111111.00"
  #       },
  #       "currency_code": "EUR",
  #       "enrollment_id": "test_enr_7aiZfKMh",
  #       "id": "test_acc_K-QfLaI=_JzKvyYA=",
  #       "institution": {
  #           "id": "citi",
  #           "name": "citi"
  #       },
  #       "links": {
  #           "self": "https://api.teller.io/accounts/test_acc_K-QfLaI=_JzKvyYA=",
  #           "transactions": "https://api.teller.io/accounts/test_acc_K-QfLaI=_JzKvyYA=/transactions"
  #       },
  #       "name": "Teller API Sandbox Checking",
  #       "routing_numbers": {
  #           "ach": "615153802"
  #       },
  #       "subtype": "checking",
  #       "type": "depository"
  #   },
  #     {
  #       "account_number": "5122860385",
  #       "balances": {
  #           "available": "333333333333.00",
  #           "ledger": "333333333333.00"
  #       },
  #       "currency_code": "EUR",
  #       "enrollment_id": "test_enr_8aiZfKMh",
  #       "id": "test_acc_f6aVKTA=_c3AlzRI=",
  #       "institution": {
  #           "id": "chase",
  #           "name": "Chase"
  #       },
  #       "links": {
  #           "self": "https://api.teller.io/accounts/test_acc_f6aVKTA=_c3AlzRI=",
  #           "transactions": "https://api.teller.io/accounts/test_acc_f6aVKTA=_c3AlzRI=/transactions"
  #       },
  #       "name": "Teller API Sandbox Checking 2",
  #       "routing_numbers": {
  #           "ach": "615153803"
  #       },
  #       "subtype": "checking",
  #       "type": "depository"
  #   }
  #   ])
  #   |> Jason.decode!(keys: :atoms)
  # end

  defp do_list_accounts(api_token) do
    generate_list_of_accounts(api_token)
  end

  # generation of accounts
  defp generate_list_of_accounts(api_token) do
    case Token.decrypt_token(api_token) do
      {"api", balance, offset} ->
        # number of accounts rem(offset, 3) - also der rest von div 3 = 0, 1 oder 2
        [
          generate_account(balance, offset),
          generate_account(Apa.add(balance, "123456.78"), offset + 2)
        ]

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
    %{
      self: "https://api.teller.io/accounts/#{account_id}",
      transactions: "https://api.teller.io/accounts/#{account_id}/transactions"
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
