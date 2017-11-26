defmodule Livedub.Repo.Migrations.AddDurationToClips do
  use Ecto.Migration

  def change do
    alter table(:clips) do
      add :duration, :float, null: false, default: 0.0
    end
  end
end
