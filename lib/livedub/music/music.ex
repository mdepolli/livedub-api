defmodule Livedub.Music do
  @moduledoc """
  The Music context.
  """

  import Ecto.Query, warn: false
  alias Livedub.Repo

  alias Livedub.{Music.Jam, Accounts.User}

  @doc """
  Returns the list of jams.

  ## Examples

      iex> list_jams()
      [%Jam{}, ...]

  """
  def list_jams do
    Repo.all(Jam)
  end

  def list_jams_for_user(user) do
    user
    |> Ecto.assoc(:managed_jams)
    |> Repo.all()
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
    attrs_with_admin = Map.put(attrs, :admin_id, user.id)

    %Jam{}
    |> Jam.changeset(attrs_with_admin)
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

  def add_user_to_jam(%Jam{} = jam, %User{} = user) do
    jam
    |> Jam.add_user_changeset(user)
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

  alias Livedub.Music.Clip

  @doc """
  Returns the list of clips.

  ## Examples

      iex> list_clips()
      [%Clip{}, ...]

  """
  def list_clips do
    Repo.all(Clip)
  end

  @doc """
  Gets a single clip.

  Raises `Ecto.NoResultsError` if the Clip does not exist.

  ## Examples

      iex> get_clip!(123)
      %Clip{}

      iex> get_clip!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clip!(id), do: Repo.get!(Clip, id)

  @doc """
  Creates a clip.

  ## Examples

      iex> create_clip(%{field: value})
      {:ok, %Clip{}}

      iex> create_clip(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clip(%User{} = user, attrs \\ %{}) do
    attrs_with_user_id = Map.put(attrs, "user_id", user.id)

    %Clip{}
    |> Clip.changeset(attrs_with_user_id)
    |> Repo.insert()
  end

  @doc """
  Updates a clip.

  ## Examples

      iex> update_clip(clip, %{field: new_value})
      {:ok, %Clip{}}

      iex> update_clip(clip, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clip(%Clip{} = clip, attrs) do
    clip
    |> Clip.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Clip.

  ## Examples

      iex> delete_clip(clip)
      {:ok, %Clip{}}

      iex> delete_clip(clip)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clip(%Clip{} = clip) do
    Repo.delete(clip)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clip changes.

  ## Examples

      iex> change_clip(clip)
      %Ecto.Changeset{source: %Clip{}}

  """
  def change_clip(%Clip{} = clip) do
    Clip.changeset(clip, %{})
  end

  alias Livedub.Music.Track

  @doc """
  Returns the list of tracks.

  ## Examples

      iex> list_tracks()
      [%Track{}, ...]

  """
  def list_tracks do
    Repo.all(Track)
  end

  @doc """
  Gets a single track.

  Raises `Ecto.NoResultsError` if the Track does not exist.

  ## Examples

      iex> get_track!(123)
      %Track{}

      iex> get_track!(456)
      ** (Ecto.NoResultsError)

  """
  def get_track!(id), do: Repo.get!(Track, id)

  @doc """
  Creates a track.

  ## Examples

      iex> create_track(%{field: value})
      {:ok, %Track{}}

      iex> create_track(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_track(attrs \\ %{}) do
    %Track{}
    |> Track.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a track.

  ## Examples

      iex> update_track(track, %{field: new_value})
      {:ok, %Track{}}

      iex> update_track(track, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_track(%Track{} = track, attrs) do
    track
    |> Track.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Track.

  ## Examples

      iex> delete_track(track)
      {:ok, %Track{}}

      iex> delete_track(track)
      {:error, %Ecto.Changeset{}}

  """
  def delete_track(%Track{} = track) do
    Repo.delete(track)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking track changes.

  ## Examples

      iex> change_track(track)
      %Ecto.Changeset{source: %Track{}}

  """
  def change_track(%Track{} = track) do
    Track.changeset(track, %{})
  end
end
