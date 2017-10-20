defmodule Livedub.Music.Jam do
  use Ecto.Schema
  import Ecto.Changeset

  alias Livedub.Music.Jam

  schema "jams" do
    field :title, :string
    many_to_many :users, Livedub.Accounts.User, join_through: "jams_users"

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
end
