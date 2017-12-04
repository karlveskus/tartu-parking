defmodule TartuParking.Router do
  use TartuParking.Web, :router

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

  scope "/", TartuParking do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    
  end
  # Other scopes may use custom stacks.
  scope "/api", TartuParking do
    pipe_through :api

    resources "/users", UserController

    resources "/parkings", ParkingAPIController, only: [:index]
    resources "/bookings", BookingAPIController, only: [:index, :create, :delete]
  end
end
