defmodule MoneyTracker.SessionController do
  use MoneyTracker.Web, :controller

  plug Guardian.Plug.EnsureNotAuthenticated, handler: __MODULE__

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, _params) do
    render conn, "index.html"
  end

  def already_authenticated(conn, _params) do
    conn
    |> put_flash(:error, "You are already authenticated!")
    |> redirect(to: "/")
  end
end
