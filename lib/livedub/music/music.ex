defmodule Livedub.Music do
  @moduledoc """
  The Music context.
  """

  import Ecto.Query, warn: false
  alias Livedub.Repo

  alias Livedub.Music.Jam
  alias Livedub.Accounts.User

  @doc """
  Returns the list of jams.

  ## Examples

      iex> list_jams()
      [%Jam{}, ...]

  """
  def list_jams do
    Repo.all(Jam)
  end

  @doc """
  Gets a single jam.

  Raises `Ecto.NoResultsError` if the Jam does not exist.

  ## Examples

      iex> get_jam!(123)
      %Jam{}

      iex> get_jam!(456)
      ** (Ecto.NoResultsError)

  """
  def get_jam!(id), do: Repo.get!(Jam, id)

  @doc """
  Creates a jam.

  ## Examples

      iex> create_jam(%{field: value})
      {:ok, %Jam{}}

      iex> create_jam(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_jam(%User{} = user, attrs \\ %{}) do
    attrs_with_users = Map.put(attrs, "users", [user])
    %Jam{}
    |> Jam.changeset(attrs_with_users)
    |> Repo.insert()
  end

  @doc """
  Updates a jam.

  ## Examples

      iex> update_jam(jam, %{field: new_value})
      {:ok, %Jam{}}

      iex> update_jam(jam, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_jam(%Jam{} = jam, attrs) do
    jam
    |> Jam.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Jam.

  ## Examples

      iex> delete_jam(jam)
      {:ok, %Jam{}}

      iex> delete_jam(jam)
      {:error, %Ecto.Changeset{}}

  """
  def delete_jam(%Jam{} = jam) do
    Repo.delete(jam)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking jam changes.

  ## Examples

      iex> change_jam(jam)
      %Ecto.Changeset{source: %Jam{}}

  """
  def change_jam(%Jam{} = jam) do
    Jam.changeset(jam, %{})
  end
end
