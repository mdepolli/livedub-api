# This script is run with:
#   mix run priv/repo/update_colors_in_tracks.exs

alias Livedub.{Music.Jam, Music.Track}

defmodule UpdateColorsInTracks do
  def run() do
    Jam
    |> Livedub.Repo.all()
    |> Enum.each(&fill_up_colors_in_jam(&1))
  end

  defp fill_up_colors_in_jam(%Jam{} = jam) do
    jam
    |> Ecto.assoc(:tracks)
    |> Livedub.Repo.all()
    |> Enum.each(&fill_up_color_in_track(&1, jam))
  end

  defp fill_up_color_in_track(%Track{} = track, %Jam{} = jam) do
    Livedub.Music.update_track(track, %{color: Livedub.Music.pick_color(jam)})
  end
end

UpdateColorsInTracks.run()
