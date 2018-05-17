defmodule Livedub.Music.Track do
  use Ecto.Schema
  import Ecto.Changeset
  alias Livedub.Music.Track

  schema "tracks" do
    field(:title, :string)
    field(:volume, :integer, default: 70)
    field(:color, :string)
    belongs_to(:user, Livedub.Accounts.User)
    belongs_to(:jam, Livedub.Music.Jam)
    has_many(:clips, Livedub.Music.Clip)

    timestamps()
  end

  @required_fields ~w(user_id jam_id title volume color)a
  @all_fields ~w()a ++ @required_fields

  @doc false
  def changeset(%Track{} = track, attrs) do
    track
    |> cast(attrs, @all_fields)
    |> cast_color()
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
    |> assoc_constraint(:jam)
    |> validate_inclusion(:volume, 0..100)
    |> validate_format(:color, ~r/\A[0-9A-F]{6}\z/)
  end

  defp cast_color(changeset) do
    if changeset.changes[:color] do
      changeset
    else
      jam = changeset.changes[:jam_id] |> Livedub.Music.get_jam()
      put_change(changeset, :color, Livedub.Music.pick_color(jam))
    end
  end
end
