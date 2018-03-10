defmodule Livedub.Music.Jam do
  use Ecto.Schema
  import Ecto.Changeset

  alias Livedub.Music.Jam
  alias Livedub.Accounts.User

  schema "jams" do
    field(:title, :string)
    belongs_to(:admin, Livedub.Accounts.User)
    has_many(:tracks, Livedub.Music.Track)
    many_to_many(:users, Livedub.Accounts.User, join_through: "jams_users")

    timestamps()
  end

  @required_fields ~w(admin_id)a
  @all_fields ~w(title)a ++ @required_fields

  @doc false
  def changeset(%Jam{} = jam, attrs) do
    jam
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end

  @doc false
  def add_user_changeset(%Jam{} = jam, %User{} = user) do
    preloaded_jam = Livedub.Repo.preload(jam, :users)

    preloaded_jam
    |> change()
    |> put_assoc(:users, Enum.uniq([user | preloaded_jam.users]))
  end
end
