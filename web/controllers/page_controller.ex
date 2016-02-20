defmodule Earth.PageController do
  use Earth.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
