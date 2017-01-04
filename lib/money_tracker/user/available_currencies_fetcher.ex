defmodule MoneyTracker.User.AvailableCurrenciesFetcher do
  @moduledoc """
  Provides functionality to fetch all available currencies for a given user.
  """

  import Ecto.Query

  alias MoneyTracker.{Repo, User, Place}

  @doc """
  Runs fetcher and returns list of currencies
  """
  @spec run(User.t) :: [String.t]
  def run(user) do
    Place
    |> Place.for_user(user)
    |> select_currency_scope
    |> Repo.all
  end

  defp select_currency_scope(query) do
    from p in query,
    select: p.currency
  end
end
