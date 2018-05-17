defmodule Livedub.Repo.Migrations.AddColorToTrack do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      add :color, :string, null: false
    end
  end
end
