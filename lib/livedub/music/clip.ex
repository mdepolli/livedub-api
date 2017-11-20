defmodule Livedub.Music.Clip do
  use Ecto.Schema
  import Ecto.Changeset
  alias Livedub.Music.Clip


  schema "clips" do
    field :url, :string
    field :start_time, :float
    belongs_to :user, Livedub.Accounts.User
    belongs_to :jam, Livedub.Music.Jam

    timestamps()
  end

  @required_fields ~w(url start_time user_id jam_id)a
  @all_fields ~w()a ++ @required_fields

  @doc false
  def changeset(%Clip{} = clip, attrs) do
    clip
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
