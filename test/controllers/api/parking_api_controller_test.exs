defmodule TartuParking.ParkingAPIControllerTest do
  use TartuParking.ConnCase
  alias TartuParking.{Repo, Parking, Zone, DataParser}

  describe "index/2 responds with all Parkings" do
    setup [:add_zone, :add_parkings]

    test "Responds with all parking places ordered by its distance from given address", %{conn: conn} do

      response =
        build_conn()
        |> get(parking_api_path(conn, :index), address: "Lossi")
        |> Map.get(:resp_body)
        |> Poison.Parser.parse!

      assert length(response) >= 1
      assert Map.get(List.first(response), "address") == "Lossi"

    end

    test "Responds with empty list of Parkings when address not given", %{conn: conn} do

      response =
        build_conn()
        |> get(parking_api_path(conn, :index))
        |> Map.get(:resp_body)
        |> Poison.Parser.parse!

      expexted = []

      assert response == expexted

    end

  end

  describe "show/2 responds with 1 parking" do
    setup [:add_zone, :add_parkings]

    test "Responds with Parking if Parking with given ID was found", %{conn: conn, parkings: parkings} do

      first_parking = List.first(parkings)

      response =
        build_conn()
        |> get(parking_api_path(conn, :show, first_parking.id))
        |> Map.get(:resp_body)
        |> Poison.Parser.parse!

      assert Map.fetch!(response, "address") == first_parking.address

    end

    test "Responds with error message if Parking with given ID was not found", %{conn: conn, parkings: parkings} do

      last_parking = List.last(parkings)

      response =
        build_conn()
        |> get(parking_api_path(conn, :show, last_parking.id + 1))
        |> Map.get(:resp_body)
        |> Poison.Parser.parse!

      expexted = %{
        "message" => "Parking not found"
      }

      assert response == expexted

    end

  end


  defp add_zone(_) do
    zone_struct = %{name: "Zone A", price_per_hour: 2.0, price_per_min: 0.12, free_time: 15}

    zone = Zone.changeset(%Zone{}, zone_struct)
           |> Repo.insert!()

    {:ok, zone: zone}
  end

  defp add_parkings(_) do
    zone =
      Repo.all(Zone)
      |> List.last()

    parkings =
      [
        %{
          address: "Lossi",
          total_slots: 20,
          zone_id: zone.id,
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
          zone_id: zone.id,
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

    {:ok, parkings: parkings}
  end

end
