defmodule SpaceArena.Repo.Migrations.CreateGameHost do
  use Ecto.Migration

  def change do
    create table(:game_hosts) do
      add :name, :string
      add :ip, :string
      add :port, :string
      add :cur_players, :integer
      add :max_players, :integer
      add :version, :string
      add :token, :string

      timestamps()
    end

  end
end
