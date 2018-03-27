defmodule LivedubWeb.MusicResolver do
  alias Livedub.{Accounts, Accounts.User, Music, Music.Jam, Music.Track, Music.Clip}

  def all_jams(_root, _args, %{context: %{current_user: current_user}}) do
    jams = Music.list_jams_for_user(current_user)
    {:ok, jams}
  end

  def get_jam(_root, %{jam_id: jam_id}, %{context: %{current_user: current_user}}) do
    with {:ok, %Jam{} = jam} <- Music.get_jam_for_user(jam_id, current_user) do
      {:ok, jam}
    else
      {:error, message} -> {:error, message: message}
    end
  end

  def create_jam(_root, %{title: title}, %{context: %{current_user: current_user}}) do
    with {:ok, %Jam{} = jam} <- Music.create_jam(current_user, %{title: title}) do
      {:ok, jam}
    else
      {:error, changeset} ->
        {:error, message: "Could not create jam", details: error_details(changeset)}
    end
  end

  def join_jam(_root, %{jam_id: jam_id}, %{context: %{current_user: current_user}}) do
    jam = Music.get_jam!(jam_id)

    with {:ok, %Jam{} = jam} <- Music.join_jam(jam, current_user) do
      {:ok, jam}
    end
  end

  def remove_user_from_jam(_root, %{jam_id: jam_id, user_id: user_id}, %{
        context: %{current_user: current_user}
      }) do
    with jams <- Music.list_jams_for_user(current_user),
         %Jam{} = jam <- Music.get_jam(jam_id),
         true <- jam in jams,
         %User{} = user <- Accounts.get_user(user_id),
         {:ok, _result} <- Music.remove_user_from_jam(jam, user) do
      {:ok, jam}
    else
      _ -> {:error, message: "Could not remove user from jam"}
    end
  end

  def delete_jam(_root, %{jam_id: jam_id}, %{context: %{current_user: current_user}}) do
    with {:ok, %Jam{} = jam} <- Music.delete_jam_for_user(jam_id, current_user) do
      {:ok, jam}
    else
      {:error, message} -> {:error, message: message}
    end
  end

  def all_tracks(_root, _args, %{context: %{current_user: current_user}}) do
    tracks = Music.list_tracks_for_user(current_user)
    {:ok, tracks}
  end

  def create_track(_root, args = %{jam_id: jam_id, title: _title}, %{
        context: %{current_user: current_user}
      }) do
    with %Jam{} = _jam <- Music.get_jam(jam_id),
         {:ok, %Track{} = track} <- Music.create_track(current_user, args) do
      {:ok, track}
    else
      {:error, changeset} ->
        {:error, message: "Could not create track", details: error_details(changeset)}
    end
  end

  def delete_track(_root, %{track_id: track_id}, %{context: %{current_user: current_user}}) do
    with %Track{} = track <- Music.get_track(track_id),
         ^current_user <- Livedub.Repo.preload(track, :user).user,
         {:ok, %Track{} = track} <- Music.delete_track(track) do
      {:ok, track}
    else
      {:error, message} -> {:error, message: message}
    end
  end

  def all_clips(_root, _args, %{context: %{current_user: current_user}}) do
    clips = Music.list_clips_for_user(current_user)
    {:ok, clips}
  end

  def create_clip(_root, args, %{context: %{current_user: current_user}}) do
    track = Music.get_track!(args[:track_id])

    with {:ok, %Clip{} = clip} <- Music.create_clip(current_user, track, args) do
      {:ok, clip}
    else
      {:error, changeset} ->
        {:error, message: "Could not create clip", details: error_details(changeset)}
    end
  end

  defp error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
