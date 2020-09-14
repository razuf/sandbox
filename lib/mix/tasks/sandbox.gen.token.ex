defmodule Mix.Tasks.Sandbox.Gen.Token do
  @shortdoc "Generates an Api Token."

  @moduledoc """
  Generates a new Api Token.

      mix sandbox.gen.token start_balance:float offset:integer

  Example:

      mix sandbox.gen.token 999999.12 8

  The first argument is any start balance with 2 decimal places (more decimal places are cut off).
  The second argument is an offset integer to generate dynamic values from the given lists.

  To use this generated api token please put it into config.exs:

      config :sandbox, sandbox_api_token: ["first_token", "second_token"]

  Or add it to ENV vars:

      export SANDBOX_API_TOKEN=first_token:second_token

  """
  use Mix.Task

  alias Apa
  alias Sandbox.Data.Token

  def run(params) do
    case params do
      [balance, offset] ->
        balance =
          balance
          |> Apa.parse()
          |> Apa.abs()
          |> Apa.to_string(-1, 2)

        offset =
          offset
          |> Apa.parse()
          |> Apa.abs()
          |> Apa.to_string(-1, 0)
          |> String.to_integer()

        api_token = Token.generate_token({"api", balance, offset})
        IO.puts("\nGenerated Api Token: #{api_token}\n\nPut it in your config.exs or ENV vars.\n")

      _ ->
        IO.puts(
          "Wrong parameter please use: mix sandbox.gen.token start_balance:float offset:integer"
        )
    end
  end
end
