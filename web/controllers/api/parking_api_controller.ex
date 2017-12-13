defmodule TartuParking.ParkingAPIController do
  @http_client Application.get_env(:tartu_parking, :http_client)
  use TartuParking.Web, :controller
  alias TartuParking.{Repo, Parking, Zone, Booking, DataParser}
  Postgrex.Types.define(
    TartuParking.PostgresTypes,
    [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
    json: Poison
  )

  def index(conn, params) do

    # Maximum distance between inserted destination and parking places in meters
    max_distance = 500

    parkings =
      case Map.fetch(params, "address") do
        :error ->
          []
        {:ok, address} ->

          %{"lat" => lat, "lng" => lng} = DataParser.get_coordinates_by_address(address)

          point = %Geo.Point{coordinates: {lng, lat}, srid: 4326}

          parkings_in_range =
            TartuParking.Parking.within(Parking, point, max_distance)
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
    started_bookings = Repo.all(from b in Booking, where: b.parking_id == ^parking.id and b.status == "started")

    %{
      address: parking.address,
      slots: %{
        total: parking.total_slots,
        available: parking.total_slots - length(started_bookings)
      },
      zone: %{
        id: zone.id,
        name: zone.name,
        price_per_hour: zone.price_per_hour,
        price_per_min: zone.price_per_min,
        free_time: zone.free_time
      },
      distance: Float.round(parking.distance),
      id: parking.id,
      coordinates:
        parking.coordinates.coordinates
        |> Enum.map(fn {lng, lat} -> %{lng: lng, lat: lat} end)
    }
  end

end