defmodule TartuParking.BookingAPIController do
  use TartuParking.Web, :controller
  alias TartuParking.{Repo,Booking,User,Parking}
  alias Ecto.{Changeset}
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do

    user_id = get_req_header(conn, "user_id")

    {status, bookings} =
      case user_id do
        [] ->
          {401, %{"message": "Authentication credentials were missing or incorrect"}}
        _ ->
          user_id = user_id |> List.first |> Integer.parse |> elem(0)

          bookings = Repo.all(from t in Booking, where: t.user_id == ^user_id, select: t)
            |> Enum.map(fn(booking) ->
            parking = Repo.get!(Parking, booking.parking_id)

            %{
              'id': booking.id,
              'user_id': booking.user_id,
              'parking': parking
            } end)

          {200, bookings}
      end
    
    conn
    |> put_status(status)
    |> json(bookings)
  end

  
  def create(conn, params) do
    IO.inspect params
    
    user_id = get_req_header(conn, "user_id")

    {status, response} = 
      case user_id do
        [] ->
          {401, %{"message": "Authentication credentials were missing or incorrect"}}
        _ ->
          user_id = user_id |> List.first |> Integer.parse |> elem(0)

          case Map.fetch(params, "parking_id") do
            :error -> 
              {400, %{"message": "Missing Parking ID"}}
            {:ok, parking_id} ->

              changeset = 
                Booking.changeset(%Booking{})
                |> Changeset.put_change(:user, Repo.get!(User, user_id))
                |> Changeset.put_change(:parking, Repo.get!(Parking, parking_id))
          
              booking = Repo.insert!(changeset)
              
              {201, %{"message": "Booking created", "booking_id": booking.id}}
          end
      end

    conn
    |> put_status(status)
    |> json(response)
  end


  def delete(conn, params) do
    
    user_id = get_req_header(conn, "user_id")
    
    {status, response} = 
      case user_id do
        [] ->
          {401, %{"message": "Authentication credentials were missing or incorrect"}}
        _ ->
          case Map.fetch(params, "id") do
            :error -> 
              {400, %{"message": "Missing Parking ID"}}
            {:ok, booking_id} ->

              booking = Repo.get(Booking, Integer.parse(booking_id) |> elem(0))

              case booking do
                nil ->
                  {404, %{"message": "Booking not found"}}
                _ ->
                  Repo.delete!(booking)
                  {200, %{"message": "Booking removed"}}
              end
          end
      end

    conn
    |> put_status(status)
    |> json(response)
  end
end