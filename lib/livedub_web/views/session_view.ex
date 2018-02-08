defmodule LivedubWeb.SessionView do
  use LivedubWeb, :view

  def render("create.json", %{user: user, jwt: jwt}) do
    %{
      status: :ok,
      data: %{
        token: jwt,
        id: user.id,
        email: user.email
      }
    }
  end
end
