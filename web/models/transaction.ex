defmodule MoneyTracker.Transaction do
  use MoneyTracker.Web, :model

  schema "transactions" do
    field :amount, :float
    field :description, :string

    belongs_to :place, MoneyTracker.Place

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:amount, :description])
    |> validate_required([:amount, :description])
  end
end
