defmodule LivedubWeb.Router do
  use LivedubWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :authorized do
    plug(
      Guardian.Plug.Pipeline,
      module: Livedub.Guardian,
      error_handler: Livedub.AuthErrorHandler
    )

    plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
    # plug Guardian.Plug.EnsureAuthenticated
    plug(Guardian.Plug.LoadResource, allow_blank: true)
    plug(LivedubWeb.Context)
  end

  scope "/graphql" do
    pipe_through(:api)
    pipe_through(:authorized)

    forward("/", Absinthe.Plug, schema: LivedubWeb.Schema)
  end

  scope "/graphiql" do
    pipe_through(:authorized)

    forward("/", Absinthe.Plug.GraphiQL, schema: LivedubWeb.Schema, interface: :advanced)
  end
end
