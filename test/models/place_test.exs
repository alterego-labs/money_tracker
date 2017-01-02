defmodule MoneyTracker.PlaceTest do
  use MoneyTracker.ModelCase

  alias MoneyTracker.Place

  @valid_attrs %{currency: "some content", description: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Place.changeset(%Place{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Place.changeset(%Place{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "for_user filters places by user" do
    user1 = insert(:user) |> with_place
    user2 = insert(:user)
    Enum.each 1..2, fn(_tick) -> with_place(user2) end
    result = Place |> Place.for_user(user2) |> Repo.all
    assert Enum.count(result) == 2
  end
end
