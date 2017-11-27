defmodule TartuParking.ParkingAPIController do
    use TartuParking.Web, :controller
    alias TartuParking.{Repo,Parking}
    
    def index(conn, _params) do
      #Takso.TaxiAllocator.find_parking(String.to_atom("#{origin}"))
      parking = TartuParking.Geolocator.find_closest_parking("Liivi 2")
      parking = parking |> List.first
      IO.inspect parking
      conn
      |> put_status(200)
      |> json(%{msg: "Your decision has been taken into account"})
    end

    # def update(conn, %{"id" => booking_id, "status" => decision}) do
    #   user = Guardian.Plug.current_resource(conn)    
    #   case decision do
    #     "rejected" ->
    #       Takso.TaxiAllocator.reject_booking(String.to_atom("booking_#{booking_id}"), user.username)
    #     "accepted" ->
    #       Takso.TaxiAllocator.accept_booking(String.to_atom("booking_#{booking_id}"), user.username)
    #   end
  
    #   conn
    #   |> put_status(200)
    #   |> json(%{msg: "Your decision has been taken into account"})
    # end
  end