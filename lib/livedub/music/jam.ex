defmodule Livedub.Music.Jam do
  use Ecto.Schema
  import Ecto.Changeset
  alias Livedub.Music.Jam


  schema "jams" do
    field :title, :string
    many_to_many :users, Livedub.Accounts.User, join_through: "jams_users"

    timestamps()
  end

  @doc false
  def changeset(%Jam{} = jam, attrs) do
    jam
    |> cast(attrs, [:title])
    |> put_assoc(:users, attrs[:users])
  end
end
