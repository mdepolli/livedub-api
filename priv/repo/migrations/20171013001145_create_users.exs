defmodule Livedub.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :full_name, :string, default: "", null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
