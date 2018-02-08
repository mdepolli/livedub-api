defmodule Livedub.Music.Jam do
  use Ecto.Schema
  import Ecto.Changeset

  alias Livedub.Music.Jam
  alias Livedub.Accounts.User

  schema "jams" do
    field(:title, :string)
    has_many(:clips, Livedub.Music.Clip)
    many_to_many(:users, Livedub.Accounts.User, join_through: "jams_users")

    timestamps()
  end

  @required_fields ~w()a
  @all_fields ~w(title)a ++ @required_fields

  @doc false
  def changeset(%Jam{} = jam, attrs) do
    jam
    |> cast(attrs, @all_fields)
    |> put_assoc(:users, attrs["users"])
  end

  def add_user_changeset(%Jam{} = jam, %User{} = user) do
    preloaded_jam = Livedub.Repo.preload(jam, :users)

    preloaded_jam
    |> change()
    |> put_assoc(:users, Enum.uniq([user | preloaded_jam.users]))
  end
end
