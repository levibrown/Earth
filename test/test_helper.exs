ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Earth.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Earth.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Earth.Repo)

