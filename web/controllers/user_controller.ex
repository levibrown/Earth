defmodule Earth.UserController do
  use Earth.Web, :controller

  alias Earth.Repo
  alias Earth.User
  alias Earth.Authorization

  def new(conn, params, current_user, _claims) do
    render conn, "new.html", current_user: current_user
  end
end
