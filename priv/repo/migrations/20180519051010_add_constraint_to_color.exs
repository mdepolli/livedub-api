defmodule Livedub.Repo.Migrations.AddConstraintToColor do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      modify :color, :string, null: false
    end
  end
end
