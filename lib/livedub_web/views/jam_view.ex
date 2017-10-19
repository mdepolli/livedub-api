defmodule LivedubWeb.JamView do
  use LivedubWeb, :view
  alias LivedubWeb.JamView

  def render("index.json", %{jams: jams}) do
    %{data: render_many(jams, JamView, "jam.json")}
  end

  def render("show.json", %{jam: jam}) do
    %{data: render_one(jam, JamView, "jam.json")}
  end

  def render("jam.json", %{jam: jam}) do
    %{id: jam.id,
      title: jam.title}
  end
end
