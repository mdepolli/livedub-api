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

  @doc false
  def changeset(%Track{} = track, attrs) do
    track
    |> cast(attrs, ~w(user_id jam_id title volume color)a)
    |> validate_required(~w(user_id jam_id title volume)a)
    |> assoc_constraint(:user)
    |> assoc_constraint(:jam)
    |> cast_color()
    |> validate_inclusion(:volume, 0..100)
    |> validate_format(:color, ~r/\A[0-9A-F]{6}\z/)
  end

  def update_changeset(%Track{} = track, attrs) do
    track
    |> cast(attrs, ~w(title volume color)a)
    |> validate_required(~w(title volume color)a)
    |> validate_inclusion(:volume, 0..100)
    |> validate_format(:color, ~r/\A[0-9A-F]{6}\z/)
  end

  defp cast_color(changeset) do
    with color when is_nil(color) <- changeset.changes[:color],
         jam_id when not is_nil(jam_id) <- changeset.changes[:jam_id],
         jam when not is_nil(jam) <- Livedub.Music.get_jam(jam_id) do
      put_change(changeset, :color, Livedub.Music.pick_color(jam))
    else
      _ -> changeset
    end
  end
end
