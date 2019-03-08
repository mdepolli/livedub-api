defmodule Livedub.Repo.Migrations.AddMuteToTrack do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      add :mute, :boolean, null: false, default: true
    end
  end
end
