defmodule LivedubWeb.JamController do
  use LivedubWeb, :controller

  alias Livedub.Music
  alias Livedub.Music.Jam

  action_fallback LivedubWeb.FallbackController

  def create(conn, %{"jam" => jam_params}) do
    current_user = Livedub.Guardian.Plug.current_resource(conn)
    with {:ok, %Jam{} = jam} <- Music.create_jam(current_user, jam_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", jam_path(conn, :show, jam))
      |> render("show.json", jam: jam)
    end
  end

  def show(conn, %{"id" => id}) do
    jam = Music.get_jam!(id)
    render(conn, "show.json", jam: jam)
  end
end
