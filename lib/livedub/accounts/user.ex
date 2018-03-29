defmodule Livedub.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Livedub.Accounts.User

  schema "users" do
    field(:email, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    field(:full_name, :string)
    field(:profile_picture, :string)
    many_to_many(:jams, Livedub.Music.Jam, join_through: "jams_users")
    has_many(:tracks, Livedub.Music.Track)
    has_many(:clips, through: [:tracks, :clips])

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, ~w(email full_name profile_picture)a)
    |> validate_required(~w(email full_name)a)
    |> validate_length(:email, min: 1, max: 255)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  @doc false
  def registration_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, ~w(password)a)
    |> validate_length(:password, min: 6, max: 100)
    |> put_password_hash()
  end

  @doc false
  def update_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, ~w(full_name password profile_picture)a)
    |> validate_length(:password, min: 6, max: 100)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
