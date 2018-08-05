defmodule Livedub.Music do
  @moduledoc """
  The Music context.
  """

  import Ecto.Query, warn: false

  alias Livedub.{Repo, Accounts.User, Music.JamUser, Music.Jam}

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
    |> Ecto.assoc(:jams)
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

  def get_jam(id), do: Repo.get(Jam, id)

  def get_jam_for_user(jam_id, %User{} = user) do
    jam = get_jam(jam_id)
    jams = list_jams_for_user(user)
    get_jam_for_user(jam, jams)
  end

  def get_jam_for_user(%Jam{} = jam, jams) do
    if jam in jams, do: jam, else: nil
  end

  def get_jam_for_user(nil, _jams), do: nil

  @doc """
  Creates a jam.

  ## Examples

      iex> create_jam(%{field: value})
      {:ok, %Jam{}}

      iex> create_jam(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_jam(attrs \\ %{}) do
    %Jam{}
    |> Jam.changeset(attrs)
    |> Repo.insert()
  end

  def create_jam(attrs, %User{} = user) do
    attrs
    |> Enum.into(%{users: [user]})
    |> create_jam()
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
    |> Jam.update_changeset(attrs)
    |> Repo.update()
  end

  def join_jam(%Jam{} = jam, %User{} = user) do
    jam
    |> Jam.add_user_changeset(user)
    |> Repo.update()
  end

  def remove_user_from_jam(%Jam{} = jam, %User{} = user) do
    jams = list_jams_for_user(user)

    if jam in jams do
      JamUser
      |> Repo.get_by(jam_id: jam.id, user_id: user.id)
      |> Repo.delete()
    else
      {:error, "Jam doesn't exist for this user"}
    end
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

  def delete_jam_for_user(jam_id, %User{} = user) do
    jam = get_jam(jam_id)
    jams = list_jams_for_user(user)

    if jam != nil and jam in jams do
      Repo.delete(jam)
    else
      {:error, "Jam doesn't exist for this user"}
    end
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

  alias Livedub.Music.Track

  @available_colors ~w(F6E23E DA4A8F 86D8FC DA4032 C41BFA FFA44D 69DE4C D1D1D0)

  @doc """
  Returns the list of tracks.

  ## Examples

      iex> list_tracks()
      [%Track{}, ...]

  """
  def list_tracks do
    Repo.all(Track)
  end

  def list_tracks_for_user(user) do
    user
    |> Ecto.assoc(:tracks)
    |> Repo.all()
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

  def get_track(id), do: Repo.get(Track, id)

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

  def create_track(attrs, %User{} = user) when is_map(attrs) do
    attrs
    |> Map.merge(%{user_id: user.id})
    |> create_track()
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
    |> Track.update_changeset(attrs)
    |> Repo.update()
  end

  def check_authorization_for_track(%Track{} = track, %User{} = current_user) do
    jam = track |> Ecto.assoc(:jam) |> Livedub.Repo.one()
    jam in list_jams_for_user(current_user)
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

  def pick_color(%Jam{} = jam) do
    Enum.random(@available_colors -- used_colors(jam))
  end

  defp used_colors(%Jam{} = jam) do
    jam
    |> Ecto.assoc(:tracks)
    |> Repo.all()
    |> Enum.map(&Map.get(&1, :color))
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

  def list_clips_for_user(user) do
    user
    |> Ecto.assoc(:clips)
    |> Repo.all()
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
  def create_clip(attrs \\ %{}) do
    %Clip{}
    |> Clip.changeset(attrs)
    |> Repo.insert()
  end

  def create_clip(attrs, %Track{} = track) do
    attrs
    |> Map.merge(%{track_id: track.id})
    |> create_clip()
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
end
