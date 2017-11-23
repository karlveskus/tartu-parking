defmodule TartuParking.ParkingAPIController do
    use TartuParking.Web, :controller
    alias TartuParking.{Repo,Parking}
    
    def create(conn, params) do
      #user = Guardian.Plug.current_resource(conn)

      Takso.TaxiAllocator.start_link(params)
      Takso.TaxiAllocator.find_parking(String.to_atom("#{origin}"))
  
      conn
      |> put_status(201)
      |> json(%{msg: "We are processing your request"})
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