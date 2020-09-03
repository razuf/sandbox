defmodule SandboxWeb.Router do
  use SandboxWeb, :router

  alias Sandbox.Data

  pipeline :api do
    plug :accepts, ["json"]
    plug :api_token
  end

  scope "/api", SandboxWeb do
    pipe_through :api

    get "/accounts", AccountController, :index
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: SandboxWeb.Telemetry
    end
  end

  defp api_token(conn, _opts) do
    assign(conn, :api_token, Data.example_api_token())
  end
end
