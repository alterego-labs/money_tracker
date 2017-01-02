defmodule MoneyTracker.Factory do
  use ExMachina.Ecto, repo: MoneyTracker.Repo

  alias MoneyTracker.User
  alias MoneyTracker.User.PasswordCryptor

  def user_factory do
    %User{
      username: Faker.Internet.user_name,
      email: Faker.Internet.email,
      encrypted_password: PasswordCryptor.encrypt("password")
    }
  end

  def with_custom_password(%User{} = user, password) do
    %{user | encrypted_password: PasswordCryptor.encrypt(password)}
  end
end
