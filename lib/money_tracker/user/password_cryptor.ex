defmodule MoneyTracker.User.PasswordCryptor do
  @moduledoc """
  Provides functions to work with users passwords.
  """

  @doc """
  Encrypts user's password
  """
  @spec encrypt(String.t) :: String.t
  @lint {Credo.Check.Design.AliasUsage, false}
  def encrypt(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

  @doc """
  Checks incoming password with the original from the DB.
  """
  @spec check(String.t, String.t) :: boolean
  @lint {Credo.Check.Design.AliasUsage, false}
  def check(password, encrypted_password) do
    Comeonin.Bcrypt.checkpw(password, encrypted_password)
  end
end
