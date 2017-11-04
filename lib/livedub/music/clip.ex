defmodule Livedub.Music.Clip do
  use Ecto.Schema
  import Ecto.Changeset
  alias Livedub.Music.Clip


  schema "clips" do
    field :url, :string
    belongs_to :user, Livedub.Accounts.User
    belongs_to :jam, Livedub.Music.Jam

    timestamps()
  end

  @doc false
  def changeset(%Clip{} = clip, attrs) do
    clip
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
