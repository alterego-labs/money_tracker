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
end
