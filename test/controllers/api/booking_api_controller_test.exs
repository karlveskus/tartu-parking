defmodule TartuParking.BookingAPIControllerTest do
  use TartuParking.ConnCase
  alias TartuParking.{Repo, Booking, User, Parking, Zone, DataParser}
  alias Ecto.{Changeset}

  describe "index/2" do
    setup [:add_users, :add_parkings, :login]

    test "returns user bookings", %{conn: conn, users: users, parkings: parkings, jwt: jwt} do

      user_parking_pairs = for i <- users, j <- parkings, do: {i, j}

      Enum.each(
        user_parking_pairs,
        fn ({user, parking}) ->
          Repo.insert!(
            Booking.changeset(
              %Booking{
                user_id: user.id,
                parking_id: parking.id,
                status: "started",
                payment_method: "hourly"
              }
            )
          )
        end
      )

      user_id = List.last(users).id

      response =
        build_conn()
        |> put_req_header("authorization", jwt)
        |> get(booking_api_path(conn, :index), user_id: user_id)
        |> Map.get(:resp_body)
        |> Poison.Parser.parse!

      assert length(response) == 2
      assert Enum.all?(response, fn (booking) -> Map.get(booking, "status") == "started" end)
    end

  end

  describe "create/2" do
    setup [:add_users, :add_parkings, :login]

    test "Creates and responds with newly created booking", %{conn: conn, parkings: parkings, jwt: jwt} do

      parking = List.last(parkings)

      %{"message" => message, "booking_id" => booking_id} =
        build_conn()
        |> put_req_header("authorization", jwt)
        |> post(booking_api_path(conn, :create), parking_id: parking.id, payment_method: "hourly")
        |> Map.get(:resp_body)
        |> Poison.Parser.parse!

      assert message == "Booking created"
      assert is_number(booking_id) == true

    end

    test "Responds with a message indicating parking ID is not specified", %{conn: conn, jwt: jwt} do

      %{"message" => message} =
        build_conn()
        |> put_req_header("authorization", jwt)
        |> post(booking_api_path(conn, :create))
        |> Map.get(:resp_body)
        |> Poison.Parser.parse!

      assert message == "Missing Parking ID"

    end

  end

  describe "update/2" do
    setup [:add_users, :add_parkings, :login]

    test "Edits and responds with the booking", %{conn: conn, users: users, parkings: parkings, jwt: jwt} do

      parking = List.last(parkings)
      user = List.last(users)

      booking = Repo.insert!(
        Booking.changeset(
          %Booking{user_id: user.id, parking_id: parking.id, payment_method: "hourly", status: "started"}
        )
      )

      %{id: booking_id} = booking

      assert Repo.get(Booking, booking_id) == "started"

      %{"message" => message} =
        build_conn()
        |> put_req_header("authorization", jwt)
        |> put(booking_api_path(conn, :update, booking_id))
        |> Map.get(:resp_body)
        |> Poison.Parser.parse!

      assert message == "Booking finished"
      assert Repo.get(Booking, booking_id) == "finished"


      assert 3 == 3

    end

  end

  defp add_users(_) do
    users =
      [
        %{name: "Harry Potter", username: "username2", password: "password"},
        %{name: "John Doe", username: "username", password: "password"}
      ]
      |> Enum.map(fn user -> User.changeset(%User{}, user) end)
      |> Enum.map(fn changeset -> Repo.insert!(changeset) end)

    {:ok, users: users}
  end

  defp login(_) do
    jwt =
      build_conn()
      |> post(session_api_path(build_conn(), :create), %{username: "username", password: "password"})
      |> Map.get(:resp_body)
      |> Poison.Parser.parse!
      |> Map.fetch!("token")

    {:ok, jwt: jwt}
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
  