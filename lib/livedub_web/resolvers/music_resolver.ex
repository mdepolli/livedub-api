defmodule LivedubWeb.MusicResolver do
  alias Livedub.{Accounts, Accounts.User, Music, Music.Jam, Music.Track, Music.Clip}

  def all_jams(_root, _args, %{context: %{current_user: current_user}}) do
    jams = Music.list_jams_for_user(current_user)
    {:ok, jams}
  end

  def get_jam(_root, %{jam_id: jam_id}, %{context: %{current_user: current_user}}) do
    with %Jam{} = jam <- Music.get_jam_for_user(jam_id, current_user) do
      {:ok, jam}
    else
      nil -> {:error, "Jam doesn't exist for this user"}
    end
  end

  def create_jam(_root, %{title: title}, %{context: %{current_user: current_user}}) do
    with {:ok, %Jam{} = jam} <- Music.create_jam(%{title: title}, current_user) do
      {:ok, jam}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
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
    with %Jam{} = jam <- Music.get_jam_for_user(jam_id, current_user),
         %User{} = user <- Accounts.get_user(user_id),
         {:ok, _} <- Music.remove_user_from_jam(jam, user) do
      {:ok, jam}
    else
      nil -> {:error, "Jam doesn't exist for this user"}
      _ -> {:error, message: "Could not remove user from jam"}
    end
  end

  def update_jam(_root, %{jam_id: jam_id, title: title}, %{context: %{current_user: current_user}}) do
    with %Jam{} = jam <- Music.get_jam_for_user(jam_id, current_user),
         {:ok, updated_jam} <- Music.update_jam(jam, %{title: title}) do
      {:ok, updated_jam}
    else
      nil ->
        {:error, "Jam doesn't exist for this user"}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, message: "Could not update jam", details: error_details(changeset)}

      _ ->
        {:error, message: "Could not update jam"}
    end
  end

  def delete_jam(_root, %{jam_id: jam_id}, %{context: %{current_user: current_user}}) do
    with {:ok, %Jam{} = jam} <- Music.delete_jam_for_user(jam_id, current_user) do
      {:ok, jam}
    else
      {:error, message} ->
        {:error, message: message}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, message: "Could not create track", details: error_details(changeset)}
    end
  end

  def all_tracks(_root, _args, %{context: %{current_user: current_user}}) do
    tracks = Music.list_tracks_for_user(current_user)
    {:ok, tracks}
  end

  def create_track(_root, args, %{context: %{current_user: current_user}}) do
    with %Jam{} = _jam <- Music.get_jam(args[:jam_id]),
         {:ok, %Track{} = track} <- Music.create_track(args, current_user) do
      {:ok, track}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, message: "Could not create track", details: error_details(changeset)}
    end
  end

  def update_track(_root, args, %{context: %{current_user: current_user}}) do
    with %Track{} = track <- Music.get_track(args[:track_id]),
         true <- Music.check_authorization_for_track(track, current_user),
         {:ok, %Track{} = updated_track} <- Music.update_track(track, args) do
      {:ok, updated_track}
    else
      nil ->
        {:error, "Track does not exist"}

      false ->
        {:error, "User is not authorized to update track"}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, message: "Could not update track", details: error_details(changeset)}
    end
  end

  def delete_track(_root, %{track_id: track_id}, %{context: %{current_user: current_user}}) do
    with %Track{} = track <- Music.get_track(track_id),
         true <- Music.check_authorization_for_track(track, current_user),
         {:ok, %Track{} = deleted_track} <- Music.delete_track(track) do
      {:ok, deleted_track}
    else
      nil ->
        {:error, "Track does not exist"}

      false ->
        {:error, "User is not authorized to delete track"}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, message: "Could not delete track", details: error_details(changeset)}
    end
  end

  def all_clips(_root, _args, %{context: %{current_user: current_user}}) do
    clips = Music.list_clips_for_user(current_user)
    {:ok, clips}
  end

  def create_clip(_root, args, %{context: %{current_user: current_user}}) do
    with %Track{} = track <- Music.get_track(args[:track_id]),
         true <- Music.check_authorization_for_track(track, current_user),
         {:ok, %Clip{} = clip} <- Music.create_clip(track, args) do
      {:ok, clip}
    else
      nil ->
        {:error, "Track does not exist"}

      false ->
        {:error, "User is not authorized to edit track"}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, message: "Could not create clip", details: error_details(changeset)}
    end
  end

  defp error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
