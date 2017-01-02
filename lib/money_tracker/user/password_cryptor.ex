defmodule MoneyTracker.User.PasswordCryptor do
  @moduledoc """
  Provides functions to work with users passwords.
  """

  @doc """
  Encrypts user's password
  """
  @spec encrypt(String.t) :: String.t
  def encrypt(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

  @doc """
  Checks incoming password with the original from the DB.
  """
  @spec check(String.t, String.t) :: boolean
  def check(password, encrypted_password) do
    Comeonin.Bcrypt.checkpw(password, encrypted_password)
  end
end
