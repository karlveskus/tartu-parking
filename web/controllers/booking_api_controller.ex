defmodule TartuParking.BookingAPIController do
  use TartuParking.Web, :controller
  alias TartuParking.{Repo,Booking,User,Parking}
  alias Ecto.{Changeset}

  def index(conn, _params) do
    user_id = 1

    bookings = 
      Repo.all(Booking)
      |> Enum.map(fn(booking) ->
        %{
          'booking_id': booking.id,
          'user_id': booking.user_id,
          'parking_id': booking.parking_id
        } end)
    
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

          IO.inspect booking

          {201, "Booking created"}
      end

    conn
    |> put_status(status)
    |> json(%{msg: response})
  end


  def delete(conn, params) do
    IO.puts "params"
    IO.inspect params

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