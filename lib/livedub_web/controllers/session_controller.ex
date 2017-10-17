defmodule LivedubWeb.SessionController do
  use LivedubWeb, :controller

  alias Livedub.Accounts
  alias Livedub.Guardian

  action_fallback LivedubWeb.FallbackController

  def create(conn, %{"email" => email, "password" => _password}) do
    with user <- Accounts.get_user_by_email!(email) do
      {:ok, jwt, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "access", token_ttl: {1, :day})
      conn
      |> render("create.json", user: user, jwt: jwt)
    end
  end

  def create(conn, _params) do
    send_resp(conn, 401, Poison.encode!(%{error: "Incorrect password"}))
  end

  def destroy(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    Guardian.revoke(jwt)
    conn
    |> send_resp(:no_content, "")
  end
end
