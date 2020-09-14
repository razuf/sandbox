# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :sandbox, SandboxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aEOwFhauRoDB1gqzTrmHS6wRsTUoYBfid3ya5BSz4THStOXjr7jIoS+ByCafk/ai",
  render_errors: [view: SandboxWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Sandbox.PubSub,
  live_view: [signing_salt: "LlkzHgqh"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :sandbox,
  sandbox_api_token: [
    "test_api_GBXKTT42_H3WBFSSY",
    "test_api_VEBMYJWP_H3WBFS6X"
  ],
  sandbox_api_url: "http://localhost:4000"

# "test_api_Mjqtblo=_PuwSHHY=",
# "test_api_K-QfLaI=_PHpU0YA=",
# "test_api_Mj9XzM0=_PuwSyE8="

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
