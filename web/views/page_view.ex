defmodule MoneyTracker.PageView do
  use MoneyTracker.Web, :view

  alias MoneyTracker.User
  alias MoneyTracker.User.{AvailableCurrenciesFetcher, BalanceForCurrencyCalculator}

  @type currency :: String.t
  @type balance :: float

  @doc """
  Calculates and returns balance amount per currency for a particular user
  """
  @spec balances_per_currency(User.t) :: [{currency, balance}]
  def balances_per_currency(%User{} = user) do
    AvailableCurrenciesFetcher.run(user)
    |> Enum.map(fn(currency) ->
      {currency, BalanceForCurrencyCalculator.run(user, currency)}
    end)
  end
end
