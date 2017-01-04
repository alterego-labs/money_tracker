defmodule MoneyTracker.Factory do
  use ExMachina.Ecto, repo: MoneyTracker.Repo

  alias MoneyTracker.{User, Place, Transaction}
  alias MoneyTracker.User.PasswordCryptor

  def user_factory do
    %User{
      username: Faker.Internet.user_name,
      email: Faker.Internet.email,
      encrypted_password: PasswordCryptor.encrypt("password")
    }
  end

  def place_factory do
    %Place{
      title: Faker.Lorem.sentence,
      currency: "USD"
    }
  end

  def transaction_factory do
    %Transaction{
      amount: 23.45
    }
  end

  def with_custom_password(%User{} = user, password) do
    %{user | encrypted_password: PasswordCryptor.encrypt(password)}
  end

  def with_place(user, opts \\ []) do
    opts = Keyword.merge(opts, [user: user])
    insert(:place, opts)
    user
  end

  def with_transaction(place, opts \\ []) do
    opts = Keyword.merge(opts, [place: place])
    insert(:transaction, opts)
    place
  end
end
