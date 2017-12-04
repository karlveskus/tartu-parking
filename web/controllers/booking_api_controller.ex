defmodule TartuParking.BookingAPIController do
  use TartuParking.Web, :controller
  alias TartuParking.{Repo,Booking,User,Parking}
  alias Ecto.{Changeset}
  import Ecto.Query, only: [from: 2]  

  def index(conn, params) do
    {status, bookings} =
      case Map.fetch(params, "user_id") do
        :error ->
          {400, []}
        {:ok, user_id} ->
          bookings = Repo.all(from t in Booking, where: t.user_id == ^user_id, select: t)
            |> Enum.map(fn(booking) ->
              %{
                'booking_id': booking.id,
                'user_id': booking.user_id,
                'parking_id': booking.parking_id
              } end)
          {200, bookings}
      end
    
    conn
    |> put_status(200)
    |> json(bookings)
  end

  
  def create(conn, params) do
    user_id = 1

    {status, response} = 
      case Map.fetch(params, "parking") do
        :error -> 
          {400, "Booking not created"}
        {:ok, parking_id} ->
          changeset = 
            Booking.changeset(%Booking{})
            |> Changeset.put_change(:user, Repo.get!(User, user_id))
            |> Changeset.put_change(:parking, Repo.get!(Parking, Integer.parse(parking_id) |> elem(0)))
      
          booking = Repo.insert!(changeset)

          {201, "Booking created"}
      end

    conn
    |> put_status(status)
    |> json(%{msg: response})
  end


  def delete(conn, params) do
    user_id = 1
    
    {status, response} = 
      case Map.fetch(params, "id") do
        :error -> 
          {400, "Booking not removed"}
        {:ok, booking_id} ->

          booking = Repo.get(Booking, Integer.parse(booking_id) |> elem(0))

          case booking do
            nil ->
              {400, "Booking not removed"}
            _ ->
              Repo.delete!(booking)
              {201, "Booking removed"}
          end

      end

    conn
    |> put_status(status)
    |> json(%{msg: response})
  end
end