defmodule Livedub.Repo.Migrations.CreateClips do
  use Ecto.Migration

  def change do
    create table(:clips) do
      add :url, :string, null: false
      add :start_time, :float, null: false
      add :duration, :float, null: false, default: 0.0
      add :recorded_at, :utc_datetime, null: false
      add :track_id, references(:tracks, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:clips, [:track_id])
  end
end
