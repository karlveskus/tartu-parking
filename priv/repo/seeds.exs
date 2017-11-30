# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TartuParking.Repo.insert!(%TartuParking.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will halt execution if something goes wrong.
alias TartuParking.{Repo, Parking}

parking_params = [
    %{name: "Alem Ethiopian Village", point: %Geo.Point{coordinates: {-87.9074701, 43.0387105}, srid: 4326}},
    %{name: "Swingin' Door Exchange", point: %Geo.Point{coordinates: {-87.9082446, 43.0372896}, srid: 4326}},
    %{name: "Milwaukee Public Market", point: %Geo.Point{coordinates: {-87.9091676, 43.035253}, srid: 4326}}
    %{name: "Odd Duck", point: %Geo.Point{coordinates: {-87.9033059, 43.0020021}, srid: 4326}}
  ]
  
  Enum.each(parking_params, fn(params) ->
    TartuParking.Parking.changeset(%TartuParking.Parking{}, params)
    |> TartuParking.Repo.insert!()
  end)