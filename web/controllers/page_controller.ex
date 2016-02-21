defmodule Earth.PageController do
  use Earth.Web, :controller

  def index(conn, params, current_user, _claims) do
    render conn, "index.html", current_user: current_user
  end
end
