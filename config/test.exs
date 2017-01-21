use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :money_tracker, MoneyTracker.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :money_tracker, MoneyTracker.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "sergio",
  password: "sergio",
  database: "money_tracker_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
