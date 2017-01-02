defmodule MoneyTracker.User do
  use MoneyTracker.Web, :model

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
end
