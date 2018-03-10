defmodule Livedub.Repo.Migrations.RemoveJamIdFromClips do
  use Ecto.Migration

  def change do
    alter table(:clips) do
      remove :jam_id
    end
  end
end
