defmodule Livedub.Repo.Migrations.AddForeignKeyConstraintsToJamsUsers do
  use Ecto.Migration

  def up do
    drop constraint(:jams_users, "jams_users_jam_id_fkey")
    alter table(:jams_users) do
      modify :jam_id, references(:jams, on_delete: :delete_all)
    end

    drop constraint(:jams_users, "jams_users_user_id_fkey")
    alter table(:jams_users) do
      modify :user_id, references(:users, on_delete: :delete_all)
    end
  end

  def down do
    drop constraint(:jams_users, "jams_users_jam_id_fkey")
    alter table(:jams_users) do
      modify :jam_id, references(:jams, on_delete: :nothing)
    end

    drop constraint(:jams_users, "jams_users_user_id_fkey")
    alter table(:jams_users) do
      modify :user_id, references(:users, on_delete: :nothing)
    end
  end
end
