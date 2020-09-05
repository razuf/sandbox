defmodule Sandbox.Data.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sandbox.Data.Balances
  alias Sandbox.Data.Institution
  alias Sandbox.Data.AccountLinks
  alias Sandbox.Data.RoutingNumbers

  @primary_key false

  embedded_schema do
    field(:account_number, :string)
    field(:currency_code, :string)
    field(:enrollment_id, :string)
    field(:id, :string)
    field(:name, :string)
    field(:subtype, :string)
    field(:type, :string)

    embeds_one(:balances, Balances)
    embeds_one(:institution, Institution)
    embeds_one(:links, AccountLinks)
    embeds_one(:routing_numbers, RoutingNumbers)
  end

  def changeset(params \\ %{}) do
    changeset(%__MODULE__{}, params)
  end

  def changeset(model, params) do
    fields = __MODULE__.__schema__(:fields)
    embeds = __MODULE__.__schema__(:embeds)
    cast_model = cast(model, params, fields -- embeds)

    Enum.reduce(embeds, cast_model, fn embed, model ->
      cast_embed(model, embed)
    end)
  end

  def get_account_by_id(api_token, account_id) do
    do_list_accounts(api_token)
    |> Enum.find(fn account -> account.id == account_id end)
  end

  def list_accounts(api_token) do
    do_list_accounts(api_token)
  end

  defp do_list_accounts("test_CQBfUQMcicDV__AhXOOCSA") do
    ~s([
      {
        "account_number": "8070518251",
        "balances": {
            "available": "144.98",
            "ledger": "144.98"
        },
        "currency_code": "USD",
        "enrollment_id": "test_enr_VUBAXEvu",
        "id": "test_acc_-LDWVmLQ",
        "institution": {
            "id": "first_republic",
            "name": "First Republic"
        },
        "links": {
            "self": "https://api.teller.io/accounts/test_acc_-LDWVmLQ",
            "transactions": "https://api.teller.io/accounts/test_acc_-LDWVmLQ/transactions"
        },
        "name": "Teller API Sandbox Checking",
        "routing_numbers": {
            "ach": "898564206"
        },
        "subtype": "checking",
        "type": "depository"
    }
    ])
    |> Jason.decode!(keys: :atoms)
  end

  defp do_list_accounts("test_api_Mjqtblo=_PuwSHHY=_LSG8Vcg=") do
    ~s([
      {
        "account_number": "5122860384",
        "balances": {
            "available": "999999.00",
            "ledger": "999999.00"
        },
        "currency_code": "USD",
        "enrollment_id": "test_enr_7aiZfKMh",
        "id": "test_acc_Mjqtblo=_PuwSyEY=_LSG91AM=",
        "institution": {
            "id": "wells_fargo",
            "name": "Wells Fargo"
        },
        "links": {
            "self": "https://api.teller.io/accounts/test_acc_Mjqtblo=_PuwSyEY=_LSG91AM=",
            "transactions": "https://api.teller.io/accounts/test_acc_Mjqtblo=_PuwSyEY=_LSG91AM=/transactions"
        },
        "name": "Teller API Sandbox Checking",
        "routing_numbers": {
            "ach": "615153802"
        },
        "subtype": "checking",
        "type": "depository"
    },
      {
        "account_number": "1234567890",
        "balances": {
            "available": "111111111111.00",
            "ledger": "111111111111.00"
        },
        "currency_code": "EUR",
        "enrollment_id": "test_enr_7aiZfKMh",
        "id": "test_acc_K-QfLaI=_JzKvyYA=_NP8A1cc=",
        "institution": {
            "id": "citi",
            "name": "citi"
        },
        "links": {
            "self": "https://api.teller.io/accounts/test_acc_K-QfLaI=_JzKvyYA=_NP8A1cc=",
            "transactions": "https://api.teller.io/accounts/test_acc_K-QfLaI=_JzKvyYA=_NP8A1cc=/transactions"
        },
        "name": "Teller API Sandbox Checking",
        "routing_numbers": {
            "ach": "615153802"
        },
        "subtype": "checking",
        "type": "depository"
    },
      {
        "account_number": "5122860385",
        "balances": {
            "available": "333333333333.00",
            "ledger": "333333333333.00"
        },
        "currency_code": "EUR",
        "enrollment_id": "test_enr_8aiZfKMh",
        "id": "test_acc_f6aVKTA=_c3AlzRI=_YL2K0VU=",
        "institution": {
            "id": "chase",
            "name": "Chase"
        },
        "links": {
            "self": "https://api.teller.io/accounts/test_acc_f6aVKTA=_c3AlzRI=_YL2K0VU=",
            "transactions": "https://api.teller.io/accounts/test_acc_f6aVKTA=_c3AlzRI=_YL2K0VU=/transactions"
        },
        "name": "Teller API Sandbox Checking 2",
        "routing_numbers": {
            "ach": "615153803"
        },
        "subtype": "checking",
        "type": "depository"
    }
    ])
    |> Jason.decode!(keys: :atoms)
  end

  defp do_list_accounts(_not_matched) do
    []
  end
end
