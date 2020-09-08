defmodule SandboxWeb.Router do
  use SandboxWeb, :router

  alias Sandbox.Data

  pipeline :api do
    plug :auth
    plug :accepts, ["json"]
  end

  pipeline :api_dev do
    plug :accepts, ["json"]
  end

  scope "/", SandboxWeb do
    pipe_through :api

    get "/accounts", AccountController, :index
    get "/accounts/:account_id", AccountController, :show
    get "/accounts/:account_id/transactions", TransactionController, :transactions
  end

  scope "/", SandboxWeb do
    pipe_through :api_dev

    get "/token", TokenController, :create
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  #   import Phoenix.LiveDashboard.Router

  #   scope "/" do
  #     pipe_through [:fetch_session, :protect_from_forgery]
  #     live_dashboard "/dashboard", metrics: SandboxWeb.Telemetry
  #   end
  # end

  defp auth(conn, _opts) do
    with {api_token, _pass} <- Plug.BasicAuth.parse_basic_auth(conn),
         :ok <- Data.find_api_token(api_token) do
      assign(conn, :api_token, api_token)
    else
      _ -> conn |> Plug.BasicAuth.request_basic_auth() |> halt()
    end
  end
end
