defmodule MoneyTracker.SessionController do
  use MoneyTracker.Web, :controller

  alias MoneyTracker.Operations.SignIn
  alias MoneyTracker.User

  plug Guardian.Plug.EnsureNotAuthenticated, handler: __MODULE__

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, %{"user" => user_params}) do
    username_or_email = Map.get(user_params, "username_or_email")
    password = Map.get(user_params, "password")
    case SignIn.run(username_or_email, password) do
      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Invalid credentials!")
        |> render("index.html")
      {:ok, %User{} = user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/")
    end
  end

  def already_authenticated(conn, _params) do
    conn
    |> put_flash(:error, "You are already authenticated!")
    |> redirect(to: "/")
  end
end
