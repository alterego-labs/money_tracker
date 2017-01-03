defmodule MoneyTracker.Plug.CurrentUserProvider do
  @moduledoc """
  Plug extension to fetch Guardian current resource and assign it to the current connection
  """

  import Plug.Conn

  @doc """
  Initializes plug extension
  """
  @spec init(Keyword.t) :: Keyword.t
  def init(opts), do: opts

  @doc """
  Calls plug
  """
  @spec call(Plug.Conn.t, Keyword.t) :: Plug.Conn.t
  def call(conn, opts) do
    key = Keyword.get(opts, :key, :default)
    user = fetch_user(conn, key)
    assign conn, :current_user, user
  end

  defp fetch_user(conn, key) do
    Guardian.Plug.current_resource(conn, key)
  end
end
