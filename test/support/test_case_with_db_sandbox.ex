defmodule TestCaseWithDbSandbox do
  @moduledoc """
  Template for ExUnit which provides implicit setup for DB sandbox.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import MoneyTracker.Factory
      alias MoneyTracker.Repo
    end
  end


  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MoneyTracker.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(MoneyTracker.Repo, {:shared, self()})
    :ok
  end
end
