defmodule MoneyTracker.Plug.PlaceFetcher do
  @moduledoc """
  A plug which fetches and assignes to the connection current place entity.
  """

  import Plug.Conn

  alias MoneyTracker.{Repo, Place}

  @doc """
  Initializes plug
  """
  def init(opts) do
    opts
  end

  @doc """
  Calls plug
  """
  @spec call(Plug.Conn.t, Map.t) :: Plug.Conn.t
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
