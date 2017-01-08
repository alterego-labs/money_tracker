defmodule MoneyTracker.TransactionController do
  use MoneyTracker.Web, :controller

  import Ecto.Query, only: [preload: 3]

  alias MoneyTracker.{Transaction, User, Place, Repo}

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    user_places = Place |> Place.for_user(user) |> Repo.all
    query = Transaction
            |> Transaction.for_places(user_places)
            |> Transaction.with_preloaded_place
            |> Transaction.recent_sorting
    transactions = Repo.all(query)
    render(conn, "index.html", transactions: transactions)
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You must to authenticate first to see this page!")
    |> redirect(to: session_path(conn, :index))
  end
end
