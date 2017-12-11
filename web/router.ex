defmodule TartuParking.Router do
  use TartuParking.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do  
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :require_login do
    plug Guardian.Plug.EnsureAuthenticated, handler: TartuParking.SessionController    
    plug :guardian_current_user
  end
  
  scope "/", TartuParking do
    pipe_through :browser # Use the default browser stack
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", TartuParking do
    pipe_through [:browser, :browser_auth]
    resources "/bookings", BookingController
    get "/", PageController, :index
  end

  scope "/api", TartuParking do
    pipe_through :api
    post "/bookings", BookingAPIController, :create
    post "/sessions", SessionAPIController, :create
    resources "/users", UserController
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  pipeline :auth_api do
    plug Guardian.Plug.EnsureAuthenticated, handler: TartuParking.SessionAPIController  
    plug :guardian_current_user  
  end

  scope "/api", TartuParking do
    pipe_through :api
    post "/sessions", SessionAPIController, :create
  end

  scope "/api", TartuParking do
    pipe_through [:api, :auth_api]
    delete "/sessions/:id", SessionAPIController, :delete
<<<<<<< HEAD

    resources "/parkings", ParkingAPIController, only: [:index]
    resources "/bookings", BookingAPIController, only: [:index, :create, :delete]
=======
    #post "/bookings", BookingAPIController, :create
>>>>>>> Add login with token
  end

  def guardian_current_user(conn, _) do
    Plug.Conn.assign(conn, :current_user, Guardian.Plug.current_resource(conn))
  end

end
