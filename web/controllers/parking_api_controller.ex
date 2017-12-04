defmodule TartuParking.ParkingAPIController do
  use TartuParking.Web, :controller
  alias TartuParking.{Repo,Parking}
  Postgrex.Types.define(TartuParking.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Poison)
  
  def index(conn, params) do

    point = %Geo.Point{coordinates: {58.365758, 26.690846}, srid: 4326}
    radius = 5000
    parkings = TartuParking.Parking.within(Parking, point, radius) 
    |> TartuParking.Parking.order_by_nearest(point) 
    |> TartuParking.Parking.select_with_distance(point) 
    |> Repo.all
    IO.inspect parkings
    
    locations = Enum.map(parkings,
    (fn park_place ->
      %{
      address: park_place.address,
      available_slots: park_place.available_slots,
      total_slots: park_place.total_slots,
      distance: park_place.distance,
      id: park_place.id,
      coordinates: Enum.map(park_place.coordinates.coordinates,
                       fn point -> {lng, lat} = point
                          %{lng: lng, lat: lat}
                       end)
      }
      end))

    conn
    |> put_status(200)
    |> json(locations)        
  end

end