defmodule MoneyTracker.LayoutView do
  @moduledoc """
  View model for the Layout
  """

  use MoneyTracker.Web, :view

  import Plug.Conn

  @doc """
  Specifies if dashboard link in the header active or not
  """
  @spec dashboard_link_active?(Plug.Conn.t) :: boolean
  def dashboard_link_active?(conn) do
    conn.request_path == "/"
  end

  @doc """
  Specifies if places link in the header active or not
  """
  @spec place_link_active?(Plug.Conn.t) :: boolean
  def place_link_active?(conn) do
    Regex.match? ~r/\/places(\/?(\d+)?\/?(\?.*)?)$/, conn.request_path
  end

  @doc """
  Specifies if transactions link in the header active or not
  """
  @spec transactions_link_active?(Plug.Conn.t) :: boolean
  def transactions_link_active?(conn) do
    Regex.match? ~r/^\/transactions(\/?(\d+)?\/?(\?.*)?)$/, conn.request_path
  end
end
