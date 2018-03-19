defmodule Livedub.Repo.Migrations.RemoveUserIdFromClips do
  use Ecto.Migration

  def change do
    alter table(:clips) do
      remove :user_id
    end
  end
end
