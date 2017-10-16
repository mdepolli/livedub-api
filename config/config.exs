# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :livedub,
  ecto_repos: [Livedub.Repo]

# Configures the endpoint
config :livedub, LivedubWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dTAe35lKpTfnKrz6L4UfgF0dSu3rEbFdPcVUyLQwjZRYvSfIr1Kh4QolGc0usbC9",
  render_errors: [view: LivedubWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Livedub.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :livedub, Livedub.Guardian,
  issuer: "Livedub",
  secret_key: "Ntoa2EwLeXUXjJpEA5lC0KLt7XGU1yOhqTalPWPv24nJ/kXeHf8LcwLm1FVWHb90",
  token_ttl: { 30, :days },
  error_handler: Livedub.AuthErrorHandler
