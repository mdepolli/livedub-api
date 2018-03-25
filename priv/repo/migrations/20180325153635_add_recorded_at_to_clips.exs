defmodule Livedub.Repo.Migrations.AddRecordedAtToClips do
  use Ecto.Migration

  def change do
    alter table(:clips) do
      add :recorded_at, :utc_datetime, null: false
    end
  end
end
