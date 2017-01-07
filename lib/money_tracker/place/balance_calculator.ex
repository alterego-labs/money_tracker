defmodule MoneyTracker.Place.BalanceCalculator do
  @moduledoc """
  Provides functionality to calculate current balance of a given place or several places.
  """

  alias MoneyTracker.{Place, Transaction, Repo}

  @doc """
  Runs calculator.
  """
  @spec run(Place.t | [Place.t]) :: float
  def run(%Place{} = place) do
    Transaction
    |> Transaction.for_place(place)
    |> Repo.all
    |> Enum.reduce(0.0, fn(transaction, acc) -> acc + transaction.amount end)
  end
  def run(places) when is_list(places) do
    Transaction
    |> Transaction.for_places(places)
    |> Repo.all
    |> Enum.reduce(0.0, fn(transaction, acc) -> acc + transaction.amount end)
  end
end
