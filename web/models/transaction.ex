defmodule MoneyTracker.Transaction do
  @moduledoc """
  Represents a Transaction entity in the system
  """

  use MoneyTracker.Web, :model

  alias MoneyTracker.Place

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

  @doc """
  Scope for filtering transactions by place
  """
  @spec for_place(Ecto.Queryable.t, Place.t) :: Ecto.Queryable.t
  def for_place(query, place) do
    from t in query,
    where: t.place_id == ^place.id
  end
end
