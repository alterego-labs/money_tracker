defmodule MoneyTracker.TransactionTest do
  use MoneyTracker.ModelCase

  alias MoneyTracker.Transaction

  @valid_attrs %{amount: "120.5", description: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Transaction.changeset(%Transaction{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Transaction.changeset(%Transaction{}, @invalid_attrs)
    refute changeset.valid?
  end
end
