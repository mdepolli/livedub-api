defmodule Livedub.Repo.Migrations.AddForeignKeyConstraintToTracks do
  use Ecto.Migration

  def up do
    drop constraint(:tracks, "tracks_user_id_fkey")
    alter table(:tracks) do
      modify :user_id, references(:users, on_delete: :delete_all)
    end
  end

  def down do
    drop constraint(:tracks, "tracks_user_id_fkey")
    alter table(:tracks) do
      modify :user_id, references(:users, on_delete: :nothing)
    end
  end
end
