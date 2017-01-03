defmodule MoneyTracker.PlaceView do
  @moduledoc """
  View model for the Place entity
  """

  use MoneyTracker.Web, :view

  alias MoneyTracker.Place

  @doc """
  Returns a balance for a given place
  """
  @spec place_balance(Place.t) :: float
  def place_balance(place) do
    Float.to_string(MoneyTracker.Place.BalanceCalculator.run(place), decimals: 2)
  end
end
