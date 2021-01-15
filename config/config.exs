# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nfl_rusher,
  ecto_repos: [NflRusher.Repo]

# Configures the endpoint
config :nfl_rusher, NflRusherWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SBUccXXOxCd2ddK7q7KSRm56kN9Qr3x2G92SXCxRwQDdYxDVV4EgnhVgPMmlJ1LA",
  render_errors: [view: NflRusherWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: NflRusher.PubSub,
  live_view: [signing_salt: "ojE6y7j2"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
