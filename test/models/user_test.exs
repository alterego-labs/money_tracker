defmodule MoneyTracker.UserTest do
  use MoneyTracker.ModelCase

  alias MoneyTracker.User

  @valid_attrs %{email: "some content", encrypted_password: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "by_username_or_email filters by username" do
    user = insert(:user)
    results = User |> User.by_username_or_email(user.username) |> Repo.all
    assert Enum.count(results) == 1
  end

  test "by_username_or_email filters by email" do
    user = insert(:user)
    results = User |> User.by_username_or_email(user.email) |> Repo.all
    assert Enum.count(results) == 1
  end
end
