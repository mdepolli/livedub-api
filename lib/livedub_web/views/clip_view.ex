defmodule LivedubWeb.ClipView do
  use LivedubWeb, :view
  alias LivedubWeb.ClipView

  def render("index.json", %{clips: clips}) do
    %{data: render_many(clips, ClipView, "clip.json")}
  end

  def render("show.json", %{clip: clip}) do
    %{data: render_one(clip, ClipView, "clip.json")}
  end

  def render("clip.json", %{clip: clip}) do
    %{id: clip.id,
      url: clip.url}
  end
end
