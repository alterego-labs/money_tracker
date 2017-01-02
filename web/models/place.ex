defmodule MoneyTracker.Place do
  use MoneyTracker.Web, :model

  schema "places" do
    field :currency, :string
    field :title, :string
    field :description, :string
    belongs_to :user, MoneyTracker.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:currency, :title, :description])
    |> validate_required([:currency, :title, :description])
  end
end
