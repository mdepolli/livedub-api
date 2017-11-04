defmodule LivedubWeb.ClipController do
  use LivedubWeb, :controller

  alias Livedub.Music
  alias Livedub.Music.Clip

  action_fallback LivedubWeb.FallbackController

  def index(conn, _params) do
    clips = Music.list_clips()
    render(conn, "index.json", clips: clips)
  end

  def create(conn, %{"clip" => clip_params}) do
    with {:ok, %Clip{} = clip} <- Music.create_clip(clip_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", clip_path(conn, :show, clip))
      |> render("show.json", clip: clip)
    end
  end

  def show(conn, %{"id" => id}) do
    clip = Music.get_clip!(id)
    render(conn, "show.json", clip: clip)
  end
end
