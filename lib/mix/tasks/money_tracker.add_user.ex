defmodule Mix.Tasks.MoneyTracker.AddUser do
  use Mix.Task

  import Mix.MoneyTracker, only: [ensure_ecto_started: 0]

  alias MoneyTracker.{Repo, User}
  alias MoneyTracker.User.PasswordCryptor

  @shortdoc "Adds new user to the system"

  @moduledoc """
  Adds new user to the system.

  Registration process to the MoneyTracker system is hidden, so the only way to register new users
  is to run `mix money_tracker:add_user` mix task. This task accepts following arguments:

  * _username_
  * _email_
  * _password_

  For example:

  ```shell
  $ mix money_tracker.add_user --username sergio --email sergio@mail.com --password password
  ```
  """

  @required_opts_keys [:username, :email, :password]

  def run(args) do
    {opts, _args, _invalid} = OptionParser.parse(args)
    case all_required_opts_keys_exists?(Keyword.keys(opts)) do
      true ->
        Mix.shell.info [:green, "Registration started..."]
        register_user(opts)
      false ->
        Mix.shell.error "You have provided an invalid options! Please check docs!"
    end
  end

  defp all_required_opts_keys_exists?(opts_keys) do
    Enum.all?(@required_opts_keys, &Enum.member?(opts_keys, &1))
  end

  defp register_user(opts) do
    ensure_ecto_started
    opts_map = Enum.into(opts, %{})
    original_password = Map.get(opts_map, :password)
    encrypted_password = PasswordCryptor.encrypt(original_password)
    opts_map = opts_map
                |> Map.put(:encrypted_password, encrypted_password)
                |> Map.delete(:password)
    user_changeset = User.register_changeset(%User{}, opts_map)
    case Repo.insert(user_changeset) do
      {:ok, _struct} ->
        Mix.shell.info [:green, "User has been registered successfully!"]
      {:error, _changeset} ->
        Mix.shell.error "Registration failed!"
    end
  end
end
