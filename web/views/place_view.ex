defmodule MoneyTracker.PlaceView do
  @moduledoc """
  View model for the Place entity
  """

  use MoneyTracker.Web, :view

  alias MoneyTracker.Place
  alias Place.BalanceCalculator

  @doc """
  Returns a balance for a given place
  """
  @spec place_balance(Place.t) :: float
  def place_balance(place) do
    place
    |> BalanceCalculator.run
    |> number_to_currency(decimals: 2, unit: place.currency)
  end
end
