defmodule MoneyTracker.User do
  @moduledoc """
  Represents an User entity in the system.
  """

  use MoneyTracker.Web, :model

  alias MoneyTracker.Repo

  @type t :: %__MODULE__{}

  schema "users" do
    field :username, :string
    field :email, :string
    field :encrypted_password, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email, :encrypted_password])
    |> validate_required([:username, :email, :encrypted_password])
  end

  @doc """
  Builds a changeset for a registration process
  """
  def register_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email, :encrypted_password])
    |> validate_required([:username, :email, :encrypted_password])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  @doc """
  Scope to filter users by username or email using a single query
  """
  @spec by_username_or_email(Ecto.Queryable.t, String.t) :: User.t | nil
  def by_username_or_email(query, username_or_email) do
    from u in query,
    where: u.username == ^username_or_email or u.email == ^username_or_email
  end
end
