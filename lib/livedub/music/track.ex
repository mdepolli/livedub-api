defmodule Livedub.Music.Track do
  use Ecto.Schema
  import Ecto.Changeset
  alias Livedub.Music.Track


  schema "tracks" do
    field :user_id, :id
    field :jam_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Track{} = track, attrs) do
    track
    |> cast(attrs, [])
    |> validate_required([])
  end
end
