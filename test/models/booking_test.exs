defmodule TartuParking.BookingTest do
  use TartuParking.ModelCase
  alias TartuParking.{Repo, User, Parking, Zone, DataParser}

  alias TartuParking.Booking

  @invalid_attrs %{}

  test "changeset with invalid attributes" do
    changeset = Booking.changeset(%Booking{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with valid attributes" do
    user = Repo.insert!(
      User.changeset(
        %User{},
        %{name: "user", username: "username", password: "password"}
      )
    )

    zone = Repo.insert!(
      Zone.changeset(
        %Zone{},
        %{name: "Zone A", price_per_hour: 2.0, price_per_min: 0.12, free_time: 15}
      )
    )

    parking = Repo.insert!(
      Parking.changeset(
        %Parking{},
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
        }
      )
    )

    changeset = Booking.changeset(
      %Booking{status: "started", user_id: user.id, parking_id: parking.id, payment_method: "hourly"}
    )
    assert changeset.valid?
  end

end
