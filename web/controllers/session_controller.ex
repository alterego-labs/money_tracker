defmodule MoneyTracker.SessionController do
  use MoneyTracker.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, _params) do
    render conn, "index.html"
  end
end
