defmodule Livedub.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Livedub.Accounts.User

  schema "users" do
    field(:email, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    has_many(:managed_jams, Livedub.Music.Jam, foreign_key: :admin_id)
    many_to_many(:jams, Livedub.Music.Jam, join_through: "jams_users")

    timestamps()
  end

  # @required_fields ~w(email password_hash)a
  # @all_fields ~w()a ++ @required_fields

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, ~w(email)a)
    |> validate_required(~w(email)a)
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
    |> put_password_hash
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
