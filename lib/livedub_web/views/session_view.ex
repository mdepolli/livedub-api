defmodule LivedubWeb.SessionView do
  use LivedubWeb, :view

  def render("create.json", %{user: user, jwt: jwt}) do
    %{
      status: :ok,
      data: %{
        token: jwt,
        email: user.email
      },
      message: "You are successfully signed in! Add this token to authorization header to make authorized requests."
    }
  end
end
