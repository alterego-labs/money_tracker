defmodule MoneyTracker.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :float
      add :description, :string
      add :place_id, references(:places, on_delete: :nothing)

      timestamps()
    end
    create index(:transactions, [:place_id])

  end
end
