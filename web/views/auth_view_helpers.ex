defmodule MoneyTracker.AuthViewHelpers do
  @moduledoc """
  Provides helper functions which are related to the authentication area
  """

  @doc """
  Specifies if current user exists or not
  """
  @spec authenticated?(Plug.Conn.t) :: boolean
  def authenticated?(conn) do
    conn.assigns[:current_user] != nil
  end
end
