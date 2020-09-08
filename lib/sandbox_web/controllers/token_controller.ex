defmodule SandboxWeb.TokenController do
  use SandboxWeb, :controller

  alias Sandbox.Data.Token

  action_fallback SandboxWeb.FallbackController

  def create(conn, params) do
    case params do
      %{"balance" => balance, "offset" => offset} ->
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

        new_token_list =
          System.get_env("SANDBOX_API_TOKEN")
          |> Kernel.<>(":")
          |> Kernel.<>(api_token)

        System.put_env("SANDBOX_API_TOKEN", new_token_list)

        render(conn, "token.json", token: api_token)

      _ ->
        {:error, :not_found}
    end
  end
end
