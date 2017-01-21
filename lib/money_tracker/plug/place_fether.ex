defmodule MoneyTracker.Plug.PlaceFetcher do
  import Plug.Conn

  alias MoneyTracker.{Repo, Place}

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    key = Keyword.get(opts, :key, :default)
    place_id = Map.get(conn.params, "place_id")
    user = fetch_user(conn, key)
    place = fetch_place_for_user(user, place_id)
    assign(conn, :place, place)
  end

  defp fetch_user(conn, key) do
    Guardian.Plug.current_resource(conn, key)
  end

  # FIXME: We must to add additinal scope to select place which is relative to the user
  defp fetch_place_for_user(user, place_id) do
    Repo.get!(Place, place_id)
  end
end
