defmodule Livedub.Repo.Migrations.CreateClips do
  use Ecto.Migration

  def change do
    create table(:clips) do
      add :url, :string, null: false
      add :start_time, :bigint, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :jam_id, references(:jams, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:clips, [:user_id])
    create index(:clips, [:jam_id])
  end
end
