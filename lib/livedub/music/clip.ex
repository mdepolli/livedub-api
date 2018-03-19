defmodule Livedub.Music.Clip do
  use Ecto.Schema
  import Ecto.Changeset
  alias Livedub.Music.Clip

  schema "clips" do
    field(:url, :string)
    field(:start_time, :float)
    field(:duration, :float)
    belongs_to(:track, Livedub.Music.Track)

    timestamps()
  end

  @required_fields ~w(url start_time duration track_id)a
  @all_fields ~w()a ++ @required_fields

  @doc false
  def changeset(%Clip{} = clip, attrs) do
    clip
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
