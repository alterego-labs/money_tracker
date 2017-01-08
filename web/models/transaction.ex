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

  @doc """
  Scope for filtering transactions by several places
  """
  def for_places(query, places) do
    place_ids = Enum.map(places, fn(place) -> place.id end)
    from t in query,
    where: t.place_id in ^place_ids
  end

  @doc """
  Scope to add place preloading
  """
  @spec with_preloaded_place(Ecto.Queryable.t) :: Ecto.Queryable.t
  def with_preloaded_place(query) do
    from t in query,
    preload: [:place]
  end

  @doc """
  Scope to add sorting by recent items.
  """
  @spec recent_sorting(Ecto.Queryable.t) :: Ecto.Queryable.t
  def recent_sorting(query) do
    from t in query,
    order_by: [desc: t.inserted_at]
  end
end
