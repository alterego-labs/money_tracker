defmodule MoneyTracker.PageController do
  use MoneyTracker.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
