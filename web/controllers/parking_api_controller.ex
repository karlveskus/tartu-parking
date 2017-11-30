defmodule TartuParking.ParkingAPIController do
  use TartuParking.Web, :controller

  Postgrex.Types.define(TartuParking.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Poison)

  
  def index(conn, params) do

    # GET /api/parkings
    #
    # Params:
    # address -> Destination address to get closest parkings for
    #
    # Returns list of closest parkings if address is specified

    parkings = 
      case Map.fetch(params, "address") do
        :error -> 
          []
        {:ok, address} -> 
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
      end

    conn
    |> put_status(200)
    |> json(parkings)
        
  end

end