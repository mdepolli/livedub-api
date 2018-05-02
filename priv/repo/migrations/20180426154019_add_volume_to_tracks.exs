defmodule Livedub.Repo.Migrations.AddVolumeToTracks do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      add :volume, :integer, null: false, default: 70
    end
  end
end
