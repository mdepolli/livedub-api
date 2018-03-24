defmodule LivedubWeb.MusicResolver do
  alias Livedub.{Music, Music.Jam, Music.Track, Music.Clip}

  def all_jams(_root, _args, %{context: %{current_user: current_user}}) do
    jams = Music.list_jams_for_user(current_user)
    {:ok, jams}
  end

  def get_jam(_root, %{jam_id: jam_id}, %{context: %{current_user: current_user}}) do
    with %Jam{} = jam <- Music.get_jam(jam_id),
         jams <- Music.list_jams_for_user(current_user),
         true <- jam in jams do
      {:ok, jam}
    else
      _ -> {:error, message: "Jam doesn't exist for this user"}
    end
  end

  def all_tracks(_root, _args, %{context: %{current_user: current_user}}) do
    tracks = Music.list_tracks_for_user(current_user)
    {:ok, tracks}
  end

  def all_clips(_root, _args, %{context: %{current_user: current_user}}) do
    clips = Music.list_clips_for_user(current_user)
    {:ok, clips}
  end

  def create_jam(_root, %{title: title}, %{context: %{current_user: current_user}}) do
    with {:ok, %Jam{} = jam} <- Music.create_jam(current_user, %{title: title}) do
      {:ok, jam}
    end
  end

  def join_jam(_root, %{jam_id: jam_id}, %{context: %{current_user: current_user}}) do
    jam = Music.get_jam!(jam_id)

    with {:ok, %Jam{} = jam} <- Music.join_jam(jam, current_user) do
      {:ok, jam}
    end
  end

  def create_track(_root, %{jam_id: jam_id}, %{
        context: %{current_user: current_user}
      }) do
    jam = Music.get_jam!(jam_id)

    with {:ok, %Track{} = track} <- Music.create_track(current_user, jam) do
      {:ok, track}
    end
  end

  def create_clip(
        _root,
        %{track_id: track_id, url: url, start_time: start_time, duration: duration},
        %{context: %{current_user: current_user}}
      ) do
    track = Music.get_track!(track_id)

    with {:ok, %Clip{} = clip} <-
           Music.create_clip(current_user, track, %{
             url: url,
             start_time: start_time,
             duration: duration
           }) do
      {:ok, clip}
    end
  end
end
