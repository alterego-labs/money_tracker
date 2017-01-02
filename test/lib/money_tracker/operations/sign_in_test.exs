defmodule MoneyTracker.Operations.SignInTest do
  use TestCaseWithDbSandbox

  alias MoneyTracker.Operations.SignIn

  alias MoneyTracker.User

  setup do
    user = build(:user) |> with_custom_password("mypassword") |> insert
    {:ok, %{user: user}}
  end

  test "run when credentials are valid and username is passed", %{user: user} do
    result = SignIn.run(user.username, "mypassword")
    assert {:ok, %User{}} = result
  end

  test "run when credentials are valid and email is passed", %{user: user} do
    result = SignIn.run(user.email, "mypassword")
    assert {:ok, %User{}} = result
  end
end
