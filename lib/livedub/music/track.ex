defmodule Livedub.Music.Track do
  use Ecto.Schema
  import Ecto.Changeset
  alias Livedub.Music.Track

  schema "tracks" do
    field(:title, :string)
    field(:volume, :integer, default: 70)
    belongs_to(:user, Livedub.Accounts.User)
    belongs_to(:jam, Livedub.Music.Jam)
    has_many(:clips, Livedub.Music.Clip)

    timestamps()
  end

  @required_fields ~w(user_id jam_id title)a
  @all_fields ~w(volume)a ++ @required_fields

  @doc false
  def changeset(%Track{} = track, attrs) do
    track
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:volume, 0..100)
  end
end
