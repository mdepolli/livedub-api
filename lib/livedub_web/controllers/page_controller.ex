defmodule LivedubWeb.PageController do
  use LivedubWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
