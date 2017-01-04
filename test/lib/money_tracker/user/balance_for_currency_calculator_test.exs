defmodule MoneyTracker.User.BalanceForCurrencyCalculatorTest do
  use TestCaseWithDbSandbox

  alias MoneyTracker.User.BalanceForCurrencyCalculator

  test "run calculates balance properly" do
    user = insert(:user)
    insert(:place, user: user, currency: "USD") |> with_transaction(amount: 10.0)
    insert(:place, user: user, currency: "EUR") |> with_transaction(amount: 11.0)
    insert(:place, user: user, currency: "USD") |> with_transaction(amount: 12.0)
    insert(:place, user: user, currency: "UAH") |> with_transaction(amount: 13.0)

    result = BalanceForCurrencyCalculator.run(user, "USD")

    assert result == 22.0
  end
end
