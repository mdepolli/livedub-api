defmodule LivedubWeb.MusicResolver do
  alias Livedub.{Music, Music.Jam}

  def create_jam(_root, %{title: title}, %{context: %{current_user: current_user}}) do
    with {:ok, %Jam{} = jam} <- Music.create_jam(current_user, %{title: title}) do
      {:ok, jam}
    end
  end

  def all_jams(_root, _args, %{context: %{current_user: current_user}}) do
    jams = Music.list_jams_for_user(current_user)
    {:ok, jams}
  end

  def all_jams(_root, _args, _info) do
    {:error, "Unauthorized"}
  end
end
