defmodule TartuParking.ParkingAPIController do
  use TartuParking.Web, :controller
  alias TartuParking.{Repo,Parking}
  
  def index(conn, params) do

    %{"address" => address} = params

    parkings = 
      TartuParking.Geolocator.find_closest_parkings(address)
      |> Enum.map(fn({parking, distance}) ->
        %{
          'address': parking.address,
          'slots': %{
            'total': parking.total_slots, 
            'available': parking.available_slots
          },
          'distance': distance |> Map.pop("status") |> elem(1)
        } end)

    conn
    |> put_status(200)
    |> json(parkings)
    
  end

end