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
end
