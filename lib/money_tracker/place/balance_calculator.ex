defmodule MoneyTracker.Place.BalanceCalculator do
  @moduledoc """
  Provides functionality to calculate current balance of a given place
  """

  alias MoneyTracker.{Place, Transaction, Repo}

  @doc """
  Runs calculator
  """
  @spec run(Place.t) :: float
  def run(place) do
    Transaction
    |> Transaction.for_place(place)
    |> Repo.all
    |> Enum.reduce(0, fn(transaction, acc) -> acc + transaction.amount end)
  end
end
