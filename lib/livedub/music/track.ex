defmodule Livedub.Music.Track do
  use Ecto.Schema
  import Ecto.Changeset
  alias Livedub.Music.Track

  schema "tracks" do
    belongs_to(:user, Livedub.Accounts.User)
    belongs_to(:jam, Livedub.Music.Jam)
    has_many(:clips, Livedub.Music.Clip)

    timestamps()
  end

  @required_fields ~w(user_id jam_id)a
  @all_fields ~w()a ++ @required_fields

  @doc false
  def changeset(%Track{} = track, attrs) do
    track
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
