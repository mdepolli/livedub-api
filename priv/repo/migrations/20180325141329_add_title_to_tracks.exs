defmodule Livedub.Repo.Migrations.AddTitleToTracks do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      add :title, :string, default: "", null: false
    end
  end
end
