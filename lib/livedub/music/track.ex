defmodule Livedub.Music.Track do
  use Ecto.Schema
  import Ecto.Changeset
  alias Livedub.Music.Track


  schema "tracks" do
    belongs_to(:user, Livedub.Accounts.User)
    belongs_to(:jam, Livedub.Music.Jam)

    timestamps()
  end

  @doc false
  def changeset(%Track{} = track, attrs) do
    track
    |> cast(attrs, [])
    |> validate_required([])
  end
end
