defmodule MoneyTracker.Operations.SignIn do
  alias MoneyTracker.User

  alias MoneyTracker.User.PasswordCryptor
  alias MoneyTracker.Repo

  @moduledoc """
  Encapsulates logic of sign in operation
  """

  @type reason :: Atom.t

  @doc """
  Runs operation processor
  """
  @spec run(String.t, String.t) :: {:ok, User.t} | {:error, reason}
  def run(username_or_email, password) do
    username_or_email
    |> fetch_user
    |> authenticate(password)
  end

  def fetch_user(username_or_email) do
    User
    |> User.by_username_or_email(username_or_email)
    |> Repo.one
  end

  defp authenticate(nil = _user, _password), do: {:error, :invalid_credentials}
  defp authenticate(user, password) do
    case PasswordCryptor.check(password, user.encrypted_password) do
      true -> {:ok, user}
      false -> {:error, :invalid_credentials}
    end
  end
end
