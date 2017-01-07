defmodule MoneyTracker.User.AvailableCurrenciesFetcherTest do
  use TestCaseWithDbSandbox, async: false

  alias MoneyTracker.User.AvailableCurrenciesFetcher

  test "run returns empty list if use has no places" do
    user = insert(:user)
    currencies = AvailableCurrenciesFetcher.run(user)
    refute Enum.any?(currencies)
  end

  test "run returns proper list of currencies" do
    user = insert(:user) |> with_place
    currencies = AvailableCurrenciesFetcher.run(user)
    assert Enum.any?(currencies)
    assert Enum.at(currencies, 0) == "USD"
  end

  test "run returns a distinct list of currencies" do
    user = insert(:user) |> with_place |> with_place
    currencies = AvailableCurrenciesFetcher.run(user)
    assert Enum.any?(currencies)
    assert Enum.count(currencies) == 1
    assert Enum.at(currencies, 0) == "USD"
  end
end
