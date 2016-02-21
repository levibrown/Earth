defmodule Earth.Router do
  use Earth.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # This plug will look for a Guardian token in the session in the default location
  # Then it will attempt to load the resource found in the JWT.
  # If it doesn't find a JWT in the default location it doesn't do anything
  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  # This pipeline if intended for API requests and looks for the JWT in the "Authorization" header
  # In this case, it should be prefixed with "Bearer" so that it's looking for
  # Authorization: Bearer <jwt>

  # pipeline :api_auth do
  #   plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  #   plug Guardian.Plug.LoadResource
  # end

  scope "/", Earth do
    # We pipe this through the browser_auth to fetch logged in people
    # We pipe this through the impersonation_browser_auth to know if we're impersonating
    # We don't just pipe it through admin_browser_auth because that also loads the resource
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
    delete "/logout", AuthController, :logout

    resources "/users", UserController
    resources "/authorizations", AuthorizationController
    resources "/tokens", TokenController

    # get "/private", PrivatePageController, :index
  end

  # This scope is the main authentication area for Ueberauth
  scope "/auth", Earth do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    get "/:identity", AuthController, :login
    get "/:identity/callback", AuthController, :callback
    post "/:identity/callback", AuthController, :callback
  end


  # Other scopes may use custom stacks.
  # scope "/api", Earth do
  #   pipe_through :api
  # end
end
