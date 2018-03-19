defmodule LivedubWeb.MusicResolver do
  alias Livedub.{Music, Music.Jam, Music.Track, Music.Clip}

  def create_jam(_root, %{title: title}, %{context: %{current_user: current_user}}) do
    with {:ok, %Jam{} = jam} <- Music.create_jam(current_user, %{title: title}) do
      {:ok, jam}
    end
  end

  def create_jam(_root, _args, _info) do
    {:error, "Unauthorized"}
  end

  def all_jams(_root, _args, %{context: %{current_user: current_user}}) do
    jams = Music.list_jams_for_user(current_user)
    {:ok, jams}
  end

  def all_jams(_root, _args, _info) do
    {:error, "Unauthorized"}
  end

  def add_user_to_jam(_root, %{jam_id: jam_id}, %{context: %{current_user: current_user}}) do
    jam = Music.get_jam!(jam_id)

    with {:ok, %Jam{} = jam} <- Music.add_user_to_jam(jam, current_user) do
      {:ok, jam}
    end
  end

  def add_user_to_jam(_root, _args, _info) do
    {:error, "Unauthorized"}
  end

  def create_track(_root, %{jam_id: jam_id}, %{context: %{current_user: current_user}}) do
    jam = Music.get_jam!(jam_id)

    with {:ok, %Track{} = track} <- Music.create_track(current_user, jam) do
      {:ok, track}
    end
  end

  def create_track(_root, _args, _info) do
    {:error, "Unauthorized"}
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

  def create_clip(_root, _args, _info) do
    {:error, "Unauthorized"}
  end
end
