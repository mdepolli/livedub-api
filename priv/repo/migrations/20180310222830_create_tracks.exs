defmodule Livedub.Repo.Migrations.CreateTracks do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :title, :string, default: "", null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :jam_id, references(:jams, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tracks, [:user_id])
    create index(:tracks, [:jam_id])
  end
end
