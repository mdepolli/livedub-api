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
    plug(Guardian.Plug.EnsureAuthenticated)
    plug(Guardian.Plug.LoadResource, ensure: true)
  end

  scope "/", LivedubWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/api", LivedubWeb do
    pipe_through(:api)

    scope "/" do
      post("/sessions", SessionController, :create)
      resources("/users", UserController, only: [:create])
    end

    scope "/" do
      pipe_through(:authorized)

      delete("/sessions", SessionController, :destroy)
      resources("/users", UserController, only: [:show])
      resources("/jams", JamController, only: [:index, :create, :show, :update])
      resources("/clips", ClipController, only: [:index, :create, :show])
    end
  end
end
