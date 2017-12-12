defmodule TartuParking.ParkingAPIControllerTest do
  use TartuParking.ConnCase
  alias TartuParking.{Repo,Parking, Zone}

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
      %{address: "Turu 6", available_slots: "20", total_slots: "20", zone_id: a,
        coordinates: %Geo.MultiPoint{coordinates: [{26.7309567,58.3771372}, {26.7321262,58.3764495}, {26.733073,58.3768869}, {26.7318392,58.3775929}, {26.7309567,58.3771372}], srid: 4326} },
      %{address: "Riia 2", available_slots: "20", total_slots: "20", zone_id: b,
        coordinates: %Geo.MultiPoint{coordinates: [{26.7276657,58.3770697}, {26.7288083,58.3763637}, {26.7302513,58.3770444}, {26.7291248,58.3776941}, {26.7276657,58.3770697}], srid: 4326} },
      %{address: "Turu 2", available_slots: "20", total_slots: "20", zone_id: a,
        coordinates: %Geo.MultiPoint{coordinates: [{26.7307717,58.3773538}, {26.7315549,58.3777279}, {26.7309755,58.378026}, {26.732499,58.3785351}, {26.7319196,58.3787714}, {26.7311472,58.3787939}, {26.7297632,58.3779219}, {26.7307717,58.3773538}], srid: 4326} }
    ]
    |> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
    |> Enum.map(fn changeset -> Repo.insert!(changeset) end)

    response = build_conn
               |> get(parking_api_path(conn, :index), address: "Turu 2")
               |> Map.get(:resp_body)
               |> Poison.Parser.parse!

    assert length(response) == 3
    assert Map.get(List.first(response), "address") == "Turu 2"
    assert Map.get(List.last(response), "address") == "Riia 2"

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
      %{address: "Turu 6", available_slots: "20", total_slots: "20", zone_id: a,
        coordinates: %Geo.MultiPoint{coordinates: [{26.7309567,58.3771372}, {26.7321262,58.3764495}, {26.733073,58.3768869}, {26.7318392,58.3775929}, {26.7309567,58.3771372}], srid: 4326} },
      %{address: "Riia 2", available_slots: "20", total_slots: "20", zone_id: b,
        coordinates: %Geo.MultiPoint{coordinates: [{26.7276657,58.3770697}, {26.7288083,58.3763637}, {26.7302513,58.3770444}, {26.7291248,58.3776941}, {26.7276657,58.3770697}], srid: 4326} },
      %{address: "Turu 2", available_slots: "20", total_slots: "20", zone_id: a,
        coordinates: %Geo.MultiPoint{coordinates: [{26.7307717,58.3773538}, {26.7315549,58.3777279}, {26.7309755,58.378026}, {26.732499,58.3785351}, {26.7319196,58.3787714}, {26.7311472,58.3787939}, {26.7297632,58.3779219}, {26.7307717,58.3773538}], srid: 4326} }
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
      %{address: "Turu 6", available_slots: "20", total_slots: "20", zone_id: a,
        coordinates: %Geo.MultiPoint{coordinates: [{26.7309567,58.3771372}, {26.7321262,58.3764495}, {26.733073,58.3768869}, {26.7318392,58.3775929}, {26.7309567,58.3771372}], srid: 4326} },
      %{address: "Riia 2", available_slots: "20", total_slots: "20", zone_id: b,
        coordinates: %Geo.MultiPoint{coordinates: [{26.7276657,58.3770697}, {26.7288083,58.3763637}, {26.7302513,58.3770444}, {26.7291248,58.3776941}, {26.7276657,58.3770697}], srid: 4326} },
      %{address: "Turu 2", available_slots: "20", total_slots: "20", zone_id: a,
        coordinates: %Geo.MultiPoint{coordinates: [{26.7307717,58.3773538}, {26.7315549,58.3777279}, {26.7309755,58.378026}, {26.732499,58.3785351}, {26.7319196,58.3787714}, {26.7311472,58.3787939}, {26.7297632,58.3779219}, {26.7307717,58.3773538}], srid: 4326} }
    ]
    |> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
    |> Enum.map(fn changeset -> Repo.insert!(changeset) end)

    response = build_conn
               |> get(parking_api_path(conn, :index), address: "Liivi 2")
               |> Map.get(:resp_body)
               |> Poison.Parser.parse!

    assert length(response) == 0
  end

end
