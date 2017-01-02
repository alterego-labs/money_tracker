defmodule MoneyTracker.PlaceController do
  use MoneyTracker.Web, :controller
  use Guardian.Phoenix.Controller

  import Ecto.Changeset, only: [put_change: 3]

  alias MoneyTracker.Place

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def index(conn, _params, user, _claims) do
    places = Place |> Place.for_user(user) |> Repo.all
    render(conn, "index.html", places: places)
  end

  def new(conn, _params, _user, _claims) do
    changeset = Place.changeset(%Place{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"place" => place_params}, user, _claims) do
    changeset = %Place{user_id: user.id}
                |> Place.changeset(place_params)

    case Repo.insert(changeset) do
      {:ok, _place} ->
        conn
        |> put_flash(:info, "Place created successfully.")
        |> redirect(to: place_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user, _claims) do
    place = fetch_place(user, id)
    render(conn, "show.html", place: place)
  end

  def edit(conn, %{"id" => id}, user, _claims) do
    place = fetch_place(user, id)
    changeset = Place.changeset(place)
    render(conn, "edit.html", place: place, changeset: changeset)
  end

  def update(conn, %{"id" => id, "place" => place_params}, user, _claims) do
    place = fetch_place(user, id)
    changeset = Place.changeset(place, place_params)

    case Repo.update(changeset) do
      {:ok, place} ->
        conn
        |> put_flash(:info, "Place updated successfully.")
        |> redirect(to: place_path(conn, :show, place))
      {:error, changeset} ->
        render(conn, "edit.html", place: place, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user, _claims) do
    place = fetch_place(user, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(place)

    conn
    |> put_flash(:info, "Place deleted successfully.")
    |> redirect(to: place_path(conn, :index))
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You must to authenticate first to see this page!")
    |> redirect(to: session_path(conn, :index))
  end

  defp fetch_place(user, place_id) do
    Place
    |> Place.for_user(user)
    |> Repo.get!(place_id)
  end
end
