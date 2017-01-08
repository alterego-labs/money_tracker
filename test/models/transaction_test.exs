defmodule MoneyTracker.TransactionTest do
  use MoneyTracker.ModelCase

  alias MoneyTracker.{Transaction, Repo}

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

  test "recent_sorting sorts properly" do
    insert(:transaction, amount: 10.0)   
    :timer.sleep(1000)
    insert(:transaction, amount: 20.0)   

    transactions = Transaction |> Transaction.recent_sorting |> Repo.all

    first_transaction = Enum.at(transactions, 0)

    assert first_transaction.amount == 20.0
  end
end
