{:ok, _} = Application.ensure_all_started(:ex_machina)

Faker.start()

Ecto.Adapters.SQL.Sandbox.mode(MoneyTracker.Repo, :manual)

ExUnit.start
