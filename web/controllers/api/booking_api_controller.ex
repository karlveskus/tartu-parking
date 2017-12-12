defmodule TartuParking.BookingAPIController do
  use TartuParking.Web, :controller
  alias TartuParking.{Repo, Booking, User, Parking}
  alias Ecto.{Changeset}
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do

    user = conn.assigns.current_user

    bookings =
      Repo.all(from t in Booking, where: t.user_id == ^user.id, select: t)
      |> Enum.map(
           fn (booking) ->
             parking = Repo.get(Parking, booking.parking_id)

             %{
               "id": booking.id,
               "parking": parking
             }
           end
         )

    conn
    |> put_status(200)
    |> json(bookings)
  end


  def create(conn, params) do

    user = conn.assigns.current_user

    {status, response} =
      case Map.fetch(params, "parking_id") do
        :error ->
          {400, %{"message": "Missing Parking ID"}}
        {:ok, parking_id} ->

          changeset =
            Booking.changeset(%Booking{})
            |> Changeset.put_change(:user, Repo.get!(User, user.id))
            |> Changeset.put_change(:parking, Repo.get!(Parking, parking_id))

          booking = Repo.insert!(changeset)

          {201, %{"message": "Booking created", "booking_id": booking.id}}
      end

    conn
    |> put_status(status)
    |> json(response)
  end


  def delete(conn, params) do

    user = conn.assigns.current_user

    {status, response} =
      case Map.fetch(params, "id") do
        :error ->
          {400, %{"message": "Missing Parking ID"}}
        {:ok, booking_id} ->

          booking_id = booking_id
                       |> Integer.parse()
                       |> elem(0)

          booking = Repo.get(Booking, booking_id)

          case booking do
            nil ->
              {404, %{"message": "Booking not found"}}
            _ ->
              Repo.delete!(booking)
              {200, %{"message": "Booking removed"}}
          end
      end

    conn
    |> put_status(status)
    |> json(response)
  end
end