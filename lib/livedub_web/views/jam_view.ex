defmodule LivedubWeb.JamView do
  use LivedubWeb, :view

  alias LivedubWeb.JamView
  alias LivedubWeb.UserView
  alias LivedubWeb.ClipView

  def render("index.json", %{jams: jams}) do
    %{data: render_many(jams, JamView, "jam.json")}
  end

  def render("show.json", %{jam: jam}) do
    %{data: render_one(jam, JamView, "jam.json")}
  end

  def render("jam.json", %{jam: jam}) do
    jam_preloaded = jam
    |> Livedub.Repo.preload(:users)
    |> Livedub.Repo.preload(:clips)
    %{
      id: jam_preloaded.id,
      title: jam_preloaded.title,
      users: render_many(jam_preloaded.users, UserView, "user.json"),
      clips: render_many(jam_preloaded.clips, ClipView, "clip.json")
    }
  end
end
