defmodule MoneyTracker.User.BalanceForCurrencyCalculator do
  @moduledoc """
  Provides functionality to calculate user's balance for a particular currency
  """

  alias MoneyTracker.{Repo, User, Place}
  alias Place.BalanceCalculator

  @doc """
  Runs fetcher and returns a balance amount
  """
  @spec run(User.t, String.t) :: float
  def run(%User{} = user, currency) do
    Place
    |> Place.for_user(user)
    |> Place.for_currency(currency)
    |> Repo.all
    |> BalanceCalculator.run
  end
end
