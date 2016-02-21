defmodule Earth.AuthorizationController do
  use Earth.Web, :controller

  use Guardian.Phoenix.Controller
  alias Earth.Repo
  alias Earth.Authorization

  plug EnsureAuthenticated, handler: __MODULE__, typ: "token"

  def index(conn, params, current_user, _claims) do
    render conn, "index.html", current_user: current_user, authorizations: authorizations(current_user)
  end

  defp authorizations(user) do
    Ecto.Model.assoc(user, :authorizations) |> Repo.all
  end

  # The unauthenticated function is called because this controller has been specified
  # as the handler. `plug EnsureAuthenticated, handler: __MODULE__, typ: "token"`
  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: auth_path(conn, :login, :identity))
  end

  def unauthorized(conn, _params) do
    conn
    |> put_flash(:error, "Unauthorized")
    |> redirect(external: redirect_back(conn))
  end
end
