defmodule MoneyTracker.Factory do
  use ExMachina.Ecto, repo: MoneyTracker.Repo

  alias MoneyTracker.{User, Place}
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
      description: Faker.Lorem.paragraph,
      currency: "USD"
    }
  end

  def with_custom_password(%User{} = user, password) do
    %{user | encrypted_password: PasswordCryptor.encrypt(password)}
  end

  def with_place(user) do
    insert(:place, user: user)
    user
  end
end
