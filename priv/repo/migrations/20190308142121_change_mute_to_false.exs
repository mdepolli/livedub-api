defmodule Livedub.Repo.Migrations.ChangeMuteToFalse do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      modify :mute, :boolean, default: false
    end
  end
end
