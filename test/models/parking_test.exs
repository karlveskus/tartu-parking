defmodule TartuParking.ParkingTest do
  use TartuParking.ModelCase

  alias TartuParking.Parking

  @valid_attrs %{
    address: "Turu 6",
    available_slots: "20",
    total_slots: "20",
    zone_id: 1,
    coordinates: %Geo.MultiPoint{
      coordinates: [
        {26.7309567, 58.3771372},
        {26.7321262, 58.3764495},
        {26.733073, 58.3768869},
        {26.7318392, 58.3775929},
        {26.7309567, 58.3771372}
      ],
      srid: 4326
    }
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Parking.changeset(%Parking{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Parking.changeset(%Parking{}, @invalid_attrs)
    refute changeset.valid?
  end
end
