defmodule MoneyTracker.Place.BalanceCalculatorTest do
  use TestCaseWithDbSandbox

  alias MoneyTracker.Place.BalanceCalculator

  test "run calcs balance for a single place" do
    user = insert(:user)
    place = insert(:place, user: user) |> with_transaction(amount: 10.0)
    result = BalanceCalculator.run(place)
    assert result == 10.0
  end

  test "run calcs balance for a bunch of places" do
    user = insert(:user)
    place1 = insert(:place, user: user) |> with_transaction(amount: 10.0)
    place2 = insert(:place, user: user) |> with_transaction(amount: 25.0)
    result = BalanceCalculator.run([place1, place2])
    assert result == 35.0
  end
end
