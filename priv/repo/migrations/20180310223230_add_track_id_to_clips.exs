defmodule Livedub.Repo.Migrations.AddTrackIdToClips do
  use Ecto.Migration

  def change do
    alter table(:clips) do
      add :track_id, references(:tracks, on_delete: :nothing), null: false
    end

    create index(:clips, [:track_id])
  end
end
