defmodule MoneyTracker.LayoutView do
  use MoneyTracker.Web, :view

  import Plug.Conn

  @doc """
  Specifies if current user exists or not
  """
  @spec authenticated?(Plug.Conn.t) :: boolean
  def authenticated?(conn) do
    conn.assigns[:current_user] != nil
  end

  @spec dashboard_link_active?(Plug.Conn.t) :: boolean
  def dashboard_link_active?(conn) do
    conn.request_path == "/"
  end

  @spec place_link_active?(Plug.Conn.t) :: boolean
  def place_link_active?(conn) do
    Regex.match? ~r/\/places(\/?(\d+)?\/?(\?.*)?)$/, conn.request_path
  end
end
