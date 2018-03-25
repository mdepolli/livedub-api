defmodule Livedub.Music.Jam do
  use Ecto.Schema
  import Ecto.Changeset

  alias Livedub.Music.Jam
  alias Livedub.Accounts.User

  schema "jams" do
    field(:title, :string)
    has_many(:tracks, Livedub.Music.Track)
    many_to_many(:users, Livedub.Accounts.User, join_through: "jams_users")

    timestamps()
  end

  @required_fields ~w()a
  @all_fields ~w(title)a ++ @required_fields

  @doc false
  def changeset(%Jam{} = jam, attrs) do
    jam
    |> cast(attrs, @all_fields)
    |> put_assoc(:users, attrs[:users])
    |> put_assoc(:tracks, attrs[:tracks])
  end

  @doc false
  def add_user_changeset(%Jam{} = jam, %User{} = user) do
    jam = Livedub.Repo.preload(jam, :users)

    jam
    |> change()
    |> put_assoc(:users, Enum.uniq([user | jam.users]))
  end
end
