defmodule TartuParking.BookingAPIControllerTest do
    use TartuParking.ConnCase
    alias TartuParking.{Repo,Booking,User,Parking}
    alias Ecto.{Changeset}    
  
    describe "index/2" do
  
      test "returns user bookings", %{conn: conn} do
        users =
          [%{name: "John Doe", username: "john.doe", password: "password"},
            %{name: "Harry Potter", username: "harry1", password: "password"}]
          |> Enum.map(fn user -> User.changeset(%User{}, user) end)
          |> Enum.map(fn changeset -> Repo.insert!(changeset) end)
        
        parkings =
          [%{address: "Vanemuise 4", available_slots: 10, total_slots: 10},
            %{address: "Turu 2", available_slots: 15, total_slots: 20},
            %{address: "Liivi 4", available_slots: 6, total_slots: 10}]
          |> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
          |> Enum.map(fn changeset -> Repo.insert!(changeset) end)

        user_parking_pairs = for i <- users, j <- parkings, do:  {i, j}
        
        Enum.each(user_parking_pairs, fn({user, parking}) ->
          Repo.insert!(Booking.changeset(%Booking{})
            |> Changeset.put_change(:user, user)
            |> Changeset.put_change(:parking, parking)) end)

        user_id = List.first(users).id

        response = build_conn
          |> get(booking_api_path(conn, :index), user_id: user_id)
          |> Map.get(:resp_body)
          |> Poison.Parser.parse!

    
        assert length(response) == 3
        assert Enum.all?(response, fn(booking) -> Map.get(booking, "user_id") == user_id end)
      end
  
    end
  
  end
  