defmodule Mix.MoneyTracker do
  def ensure_ecto_started do
    {:ok, _} = Application.ensure_all_started(:ecto)
    repos = Application.get_env(:money_tracker, :ecto_repos)
    Enum.each(repos, &ensure_repo_started(&1))
  end

  defp ensure_repo_started(repo) do
    {:ok, apps} = repo.__adapter__.ensure_all_started(repo, :temporary)
    repo.start_link(pool_size: 1)
  end
end