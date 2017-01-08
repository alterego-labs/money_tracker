defmodule MoneyTracker.Repo.Migrations.FixCharsets do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE places CONVERT TO CHARACTER SET utf8;"
    execute "ALTER TABLE transactions CONVERT TO CHARACTER SET utf8;"
    execute "ALTER DATABASE #{current_db_name} CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
  end

  defp current_db_name do
    :money_tracker
    |> Application.get_env(MoneyTracker.Repo)
    |> Keyword.get(:database)
  end
end
