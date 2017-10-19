defmodule Livedub.Repo.Migrations.CreateJams do
  use Ecto.Migration

  def change do
    create table(:jams) do
      add :title, :string

      timestamps()
    end
  end
end
