defmodule MoneyTracker.TransactionController do
  use MoneyTracker.Web, :controller
  use Guardian.Phoenix.Controller

  alias MoneyTracker.Transaction

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__
  plug MoneyTracker.Plug.PlaceFetcher, key: :default

  def index(conn, _params, user, _claims) do
    place = conn.assigns[:place]
    transactions = Transaction |> Transaction.for_place(place) |> Repo.all
    render(conn, "index.html", transactions: transactions)
  end

  def new(conn, _params, user, _claims) do
    changeset = Transaction.changeset(%Transaction{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"transaction" => transaction_params}, user, _claims) do
    place = conn.assigns[:place]
    changeset = Transaction.changeset(%Transaction{place_id: place.id}, transaction_params)

    case Repo.insert(changeset) do
      {:ok, _transaction} ->
        conn
        |> put_flash(:info, "Transaction created successfully.")
        |> redirect(to: place_transaction_path(conn, :index, place))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user, _claims) do
    place = conn.assigns[:place]
    transaction = Transaction |> Transaction.for_place(place) |> Repo.get!(id)
    render(conn, "show.html", transaction: transaction)
  end

  def edit(conn, %{"id" => id}, user, _claims) do
    place = conn.assigns[:place]
    transaction = Transaction |> Transaction.for_place(place) |> Repo.get!(id)
    changeset = Transaction.changeset(transaction)
    render(conn, "edit.html", transaction: transaction, changeset: changeset)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}, user, _claims) do
    place = conn.assigns[:place]
    transaction = Transaction |> Transaction.for_place(place) |> Repo.get!(id)
    changeset = Transaction.changeset(transaction, transaction_params)

    case Repo.update(changeset) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction updated successfully.")
        |> redirect(to: place_transaction_path(conn, :show, place, transaction))
      {:error, changeset} ->
        render(conn, "edit.html", transaction: transaction, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user, _claims) do
    place = conn.assigns[:place]
    transaction = Transaction |> Transaction.for_place(place) |> Repo.get!(id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(transaction)

    conn
    |> put_flash(:info, "Transaction deleted successfully.")
    |> redirect(to: place_transaction_path(conn, :index, place))
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You must to authenticate first to see this page!")
    |> redirect(to: session_path(conn, :index))
  end
end
