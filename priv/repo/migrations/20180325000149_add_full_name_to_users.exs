defmodule Livedub.Repo.Migrations.AddFullNameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :full_name, :string, null: false
    end
  end
end
