defmodule LivedubWeb.UserController do
  use LivedubWeb, :controller

  alias Livedub.Accounts
  alias Livedub.Accounts.User

  action_fallback LivedubWeb.FallbackController

  # def index(conn, _params) do
  #   users = Accounts.list_users()
  #   render(conn, "index.json", users: users)
  # end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      {:ok, jwt, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "access", token_ttl: {1, :day})
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("create.json", user: user, jwt: jwt)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = Accounts.get_user!(id)

  #   with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
  #     render(conn, "show.json", user: user)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   user = Accounts.get_user!(id)
  #   with {:ok, %User{}} <- Accounts.delete_user(user) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
