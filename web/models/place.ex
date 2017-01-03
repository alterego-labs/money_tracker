defmodule MoneyTracker.Place do
  @moduledoc """
  Represents a Money Place entity in the system
  """

  use MoneyTracker.Web, :model

  alias MoneyTracker.User

  schema "places" do
    field :currency, :string
    field :title, :string
    field :description, :string

    belongs_to :user, MoneyTracker.User
    has_many :transactions, MoneyTracker.Transaction

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:currency, :title, :description, :user_id])
    |> validate_required([:currency, :title, :description, :user_id])
  end

  @doc """
  Scope to filter places by user
  """
  @spec for_user(Ecto.Queryable.t, User.t) :: Ecto.Queryable.t
  def for_user(query, %User{} = user) do
    from p in query,
    where: p.user_id == ^user.id
  end
end
