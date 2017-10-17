defmodule LivedubWeb.SessionController do
  use LivedubWeb, :controller

  alias Livedub.Accounts

  action_fallback LivedubWeb.FallbackController

  def create(conn, %{"email" => email, "password" => _password}) do
    with user <- Accounts.get_user_by_email!(email) do
      conn
      |> Livedub.Guardian.Plug.sign_in(user)
      |> send_resp(:no_content, "")
    end
  end

  def create(conn, _params) do
    send_resp(conn, 401, Poison.encode!(%{error: "Incorrect password"}))
  end

  def destroy(conn, _params) do
    conn
    |> Livedub.Guardian.Plug.sign_out()
    |> send_resp(:no_content, "")
  end
end
