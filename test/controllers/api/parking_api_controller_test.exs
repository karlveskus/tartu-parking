defmodule TartuParking.ParkingAPIControllerTest do
  use TartuParking.ConnCase
  alias TartuParking.{Repo,Parking, Zone, DataParser}

  test "GET /api/parkings 2 of 3 total parkings available: returns nearest parking places", %{conn: conn} do
    
    zones =
      [
        %{name: "Zone A", price_per_hour: 2.0, price_per_min: 0.12, free_time: 15},
        %{name: "Zone B", price_per_hour: 1.0, price_per_min: 0.08, free_time: 90}
      ]
      |> Enum.map(fn zone -> Zone.changeset(%Zone{}, zone) end)
      |> Enum.map(fn changeset -> Repo.insert!(changeset) end)

    a = List.first(zones).id
    b = List.last(zones).id

    [
      %{address: "Lossi", 
        total_slots: "20", 
        zone_id: a,
        pin_lng: "Lossi"
        |> DataParser.get_coordinates_by_address()
        |> Map.get("lng"),
        pin_lat: "Lossi"
        |> DataParser.get_coordinates_by_address()
        |> Map.get("lat"),
        coordinates: %Geo.MultiPoint{coordinates: [{26.7155421,58.3786729}, {26.7156547,58.3786659}, {26.7159605,58.378957}, {26.7164808,58.3793451},{26.7167598,58.3793873}, 
        {26.7208904,58.3801776}, {26.7208991,58.3802399}, {26.7176234,58.3796348}, {26.7164218,58.3793929}, {26.7157513,58.3788782}, {26.7155421,58.3786729}],
        srid: 4326} }
    ]
    |> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
    |> Enum.map(fn changeset -> Repo.insert!(changeset) end)

    response = build_conn
               |> get(parking_api_path(conn, :index), address: "Liivi 2")
               |> Map.get(:resp_body)
               |> Poison.Parser.parse!

    assert length(response) == 1
    assert Map.get(List.first(response), "address") == "Lossi" 

  end

  test "No address specified: returns empty list", %{conn: conn} do
    zones =
      [ %{name: "Zone A", price_per_hour: 2.0, price_per_min: 0.12, free_time: 15},
        %{name: "Zone B", price_per_hour: 1.0, price_per_min: 0.08, free_time: 90} ]
      |> Enum.map(fn zone -> Zone.changeset(%Zone{}, zone) end)
      |> Enum.map(fn changeset -> Repo.insert!(changeset) end)

    a = List.first(zones).id
    b = List.last(zones).id

    [
      %{address: "Lossi", 
        total_slots: "20", 
        zone_id: a,
        pin_lng: "Lossi"
        |> DataParser.get_coordinates_by_address()
        |> Map.get("lng"),
        pin_lat: "Lossi"
        |> DataParser.get_coordinates_by_address()
        |> Map.get("lat"),
        coordinates: %Geo.MultiPoint{coordinates: [{26.7155421,58.3786729}, {26.7156547,58.3786659}, {26.7159605,58.378957}, {26.7164808,58.3793451},{26.7167598,58.3793873}, 
        {26.7208904,58.3801776}, {26.7208991,58.3802399}, {26.7176234,58.3796348}, {26.7164218,58.3793929}, {26.7157513,58.3788782}, {26.7155421,58.3786729}],
        srid: 4326} }
    ]
    |> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
    |> Enum.map(fn changeset -> Repo.insert!(changeset) end)

    response = build_conn
               |> get(parking_api_path(conn, :index), %{})
               |> Map.get(:resp_body)
               |> Poison.Parser.parse!

    assert length(response) == 0
  end

  test "0 parkings available: returns emptly list", %{conn: conn} do
    zones =
      [ %{name: "Zone A", price_per_hour: 2.0, price_per_min: 0.12, free_time: 15},
        %{name: "Zone B", price_per_hour: 1.0, price_per_min: 0.08, free_time: 90} ]
      |> Enum.map(fn zone -> Zone.changeset(%Zone{}, zone) end)
      |> Enum.map(fn changeset -> Repo.insert!(changeset) end)

    a = List.first(zones).id
    b = List.last(zones).id

    [
      %{address: "Lossi", 
        total_slots: "20", 
        zone_id: a,
        pin_lng: "Lossi"
        |> DataParser.get_coordinates_by_address()
        |> Map.get("lng"),
        pin_lat: "Lossi"
        |> DataParser.get_coordinates_by_address()
        |> Map.get("lat"),
        coordinates: %Geo.MultiPoint{coordinates: [{26.7155421,58.3786729}, {26.7156547,58.3786659}, {26.7159605,58.378957}, {26.7164808,58.3793451},{26.7167598,58.3793873}, 
        {26.7208904,58.3801776}, {26.7208991,58.3802399}, {26.7176234,58.3796348}, {26.7164218,58.3793929}, {26.7157513,58.3788782}, {26.7155421,58.3786729}],
        srid: 4326} }
    ]
    |> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
    |> Enum.map(fn changeset -> Repo.insert!(changeset) end)

    response = build_conn
               |> get(parking_api_path(conn, :index), address: "Turu 2")
               |> Map.get(:resp_body)
               |> Poison.Parser.parse!

    assert length(response) == 0
  end


end
