defmodule TartuParking.ParkingAPIControllerTest do
  use TartuParking.ConnCase
  alias TartuParking.{Repo, Parking, Zone, DataParser}

  def do_add_zone() do
    zone_struct = %{name: "Zone A", price_per_hour: 2.0, price_per_min: 0.12, free_time: 15}

    Zone.changeset(%Zone{}, zone_struct)
    |> Repo.insert!()
  end

  def do_add_parking(zone_id) do
    [
      %{
        address: "Lossi",
        total_slots: 20,
        zone_id: zone_id,
        pin_lng:
          "Lossi"
          |> DataParser.get_coordinates_by_address()
          |> Map.get("lng"),
        pin_lat:
          "Lossi"
          |> DataParser.get_coordinates_by_address()
          |> Map.get("lat"),
        coordinates: %Geo.MultiPoint{
          coordinates: [
            {26.7155421, 58.3786729},
            {26.7156547, 58.3786659},
            {26.7159605, 58.378957},
            {26.7164808, 58.3793451},
            {26.7167598, 58.3793873},
            {26.7208904, 58.3801776},
            {26.7208991, 58.3802399},
            {26.7176234, 58.3796348},
            {26.7164218, 58.3793929},
            {26.7157513, 58.3788782},
            {26.7155421, 58.3786729}
          ],
          srid: 4326
        }
      },
      %{
        address: "Uueturu",
        total_slots: 20,
        zone_id: zone_id,
        pin_lng:
          "Uueturu"
          |> DataParser.get_coordinates_by_address()
          |> Map.get("lng"),
        pin_lat:
          "Uueturu"
          |> DataParser.get_coordinates_by_address()
          |> Map.get("lat"),
        coordinates: %Geo.MultiPoint{
          coordinates: [
            {26.7249486, 58.377403},
            {26.7250022, 58.3773693},
            {26.7252302, 58.3774775},
            {26.7255065, 58.3776083},
            {26.7258015, 58.3777518},
            {26.7259008, 58.3778052},
            {26.7258444, 58.3778305},
            {26.7256191, 58.3777251},
            {26.7253026, 58.3775661},
            {26.7250478, 58.3774466},
            {26.7249486, 58.377403},
          ],
          srid: 4326
        }
      }
    ]
    |> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
    |> Enum.map(fn changeset -> Repo.insert!(changeset) end)
  end

  test "GET /api/parkings, returns parking places, closest first", %{conn: conn} do

    zone = do_add_zone()
    do_add_parking(zone.id)

    response =
      build_conn()
      |> get(parking_api_path(conn, :index), address: "Lossi")
      |> Map.get(:resp_body)
      |> Poison.Parser.parse!

    assert length(response) >= 1
    assert Map.get(List.first(response), "address") == "Lossi"

  end

  test "GET /api/parkings, no address specified, returns empty list", %{conn: conn} do

    zone = do_add_zone()
    do_add_parking(zone.id)

    response =
      build_conn()
      |> get(parking_api_path(conn, :index), %{})
      |> Map.get(:resp_body)
      |> Poison.Parser.parse!

    assert length(response) == 0

  end

  test "GET /api/parkings/:id, returns parking place with given ID", %{conn: conn} do

    zone = do_add_zone()
    parkings = do_add_parking(zone.id)
    first_parking = List.first(parkings)

    response =
      build_conn()
      |> get(parking_api_path(conn, :show, first_parking.id))
      |> Map.get(:resp_body)
      |> Poison.Parser.parse!

    assert Map.fetch!(response, "address") == first_parking.address

  end

  test "GET /api/parkings/:id, returns parking ID not found", %{conn: conn} do

    zone = do_add_zone()
    parkings = do_add_parking(zone.id)
    last_parking = List.last(parkings)

    response =
      build_conn()
      |> get(parking_api_path(conn, :show, last_parking.id + 1))
      |> Map.get(:resp_body)
      |> Poison.Parser.parse!

    assert Map.fetch!(response, "message") == "Parking not found"

  end

end
