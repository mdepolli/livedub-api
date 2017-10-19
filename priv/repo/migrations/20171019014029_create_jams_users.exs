defmodule Livedub.Repo.Migrations.CreateJamsUsers do
  use Ecto.Migration

  def change do
    create table(:jams_users) do
      add :jam_id, references(:jams), null: false
      add :user_id, references(:users), null: false
    end

    create index("jams_users", [:jam_id])
    create index("jams_users", [:user_id])
    create unique_index("jams_users", [:jam_id, :user_id])
  end
end
