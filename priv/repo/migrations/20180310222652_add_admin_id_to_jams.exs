defmodule Livedub.Repo.Migrations.AddAdminIdToJams do
  use Ecto.Migration

  def change do
    alter table(:jams) do
      add :admin_id, references(:users, on_delete: :nothing), null: false
    end

    create index(:jams, [:admin_id])
  end
end
