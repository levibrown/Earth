defmodule Earth.UserController do
  use Earth.Web, :controller

  alias Earth.Repo
  alias Earth.User
  alias Earth.Authorization

  def new(conn, params, current_user, _claims) do
    if current_user do
      conn
      |> put_flash(:info, "You must sign out to create a new user.")
      |> redirect(to: page_path(conn, :index))
    else
      render conn, "new.html", current_user: current_user
    end
  end
end
