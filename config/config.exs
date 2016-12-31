# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :money_tracker,
  ecto_repos: [MoneyTracker.Repo]

# Configures the endpoint
config :money_tracker, MoneyTracker.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Q+z3TtYjwGP7vjwZk3iAkUNra2tat2CvPoiH7ba7aFSRvXXXj/CnrX6C1g/H1Jsl",
  render_errors: [view: MoneyTracker.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MoneyTracker.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
