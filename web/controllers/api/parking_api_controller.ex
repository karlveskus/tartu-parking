defmodule TartuParking.ParkingAPIController do
  @http_client Application.get_env(:tartu_parking, :http_client)
  use TartuParking.Web, :controller
  alias TartuParking.{Repo, Parking, Zone}
  Postgrex.Types.define(TartuParking.PostgresTypes,
    [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
    json: Poison)
  
  def index(conn, params) do

    # Maximum distance between inserted destination and parking places in meters
    max_distance = 500

    parkings =
      case Map.fetch(params, "address") do
        :error ->
          []
        {:ok, address} ->
          
          url = URI.encode("https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBQek7NQLBPy99BvR8O9Z1SPzCs9OasrSo&address=#{address},+Tartu+city,+Estonia")

          # Parse distances
          %{"body": body} = @http_client.get!(url)
          %{"results" => results} = Poison.Parser.parse!(body)
          %{"geometry" => geometry} = List.first(results)
          %{"location" => location} = geometry
          %{"lng" => lng, "lat" => lat} = location

          point = %Geo.Point{coordinates: {lng, lat}, srid: 4326}
          
          parkings_in_range = TartuParking.Parking.within(Parking, point, max_distance) 
            |> TartuParking.Parking.order_by_nearest(point) 
            |> TartuParking.Parking.select_with_distance(point) 
            |> Repo.all
            |> Enum.map(fn (parking) -> format_parking(parking) end)
            
          parkings_in_range
        end

    conn
    |> put_status(200)
    |> json(parkings)
  end

  def format_parking(parking) do
    zone = Repo.get!(Zone, parking.zone_id)
    %{
      address: parking.address,
      slots: %{
        total: parking.total_slots, 
      },
      zone: %{
        id:   zone.id,
        name: zone.name,
        price_per_hour: zone.price_per_hour,
        price_per_min:  zone.price_per_min,
        free_time:      zone.free_time
      },
      distance: parking.distance |> Float.round(),
      id: parking.id,
      coordinates: parking.coordinates.coordinates |> Enum.map(fn {lng, lat} -> %{lng: lng, lat: lat} end)
    }
  end

end