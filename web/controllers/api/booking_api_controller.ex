defmodule TartuParking.BookingAPIController do
  use TartuParking.Web, :controller
  alias TartuParking.{Repo, Booking, Parking, Zone}
  import Ecto.Query, only: [from: 2]
  import Ecto.DateTime

  def index(conn, _params) do

    user = conn.assigns.current_user

    bookings =
      Repo.all(from t in Booking, where: t.user_id == ^user.id, select: t)
      |> Enum.map(
           fn (booking) ->
             parking = Repo.get(Parking, booking.parking_id)
             zone = Repo.get(Zone, parking.zone_id)

             %{
               "id": booking.id,
               "parking": %{
                 "id": parking.id,
                 "address": parking.address,
                 "total_slots": parking.total_slots,
                 "pin_lng": parking.pin_lng,
                 "pin_lat": parking.pin_lat,
                 "zone": zone
               },
               "status": booking.status,
               "start_time": booking.inserted_at,
               "payment_method": booking.payment_method
             }
           end
         )

    conn
    |> put_status(200)
    |> json(bookings)
  end

  def create(conn, %{"parking_id" => parking_id, "payment_method" => payment_method}) do

    IO.inspect conn

    user = conn.assigns.current_user

    changeset =
      Booking.changeset(
        %Booking{},
        %{
          status: "started",
          user_id: user.id,
          parking_id: parking_id,
          payment_method: payment_method
        }
      )

    {status, response} =
      case Repo.insert(changeset) do
        {:error, _msg} ->
          {500, %{"message": "Internal error"}}

        {:ok, booking} ->
          {201, %{"message": "Booking created", "booking_id": booking.id}}
      end

    conn
    |> put_status(status)
    |> json(response)
  end

  def create(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{"message": "Missing Parking ID"})
  end


  def update(conn, %{"id" => booking_id}) do

    user = conn.assigns.current_user

    query = from b in Booking, where: b.id == ^booking_id and b.user_id == ^user.id
    booking = query
              |> Repo.all()
              |> List.first()

    {status, response} =
      case booking do
        nil ->
          {404, %{"message": "Booking not found"}}

        _ ->
          booking = Ecto.Changeset.change booking, status: "finished"

          parking = Repo.get(Parking, booking.data.parking_id)

          case Repo.update booking do
            {:ok, struct} ->
              {price, start_time, end_time} = do_price_for_parking(booking)
              {
                200,
                %{
                  "message": "Booking finished",
                  "price": price,
                  "start_time": start_time,
                  "end_time": end_time,
                  "address": parking.address
                }
              }

            {:error, _changeset} ->
              {500, %{"message": "Internal error"}}
          end
      end

    conn
    |> put_status(status)
    |> json(response)
  end

  def do_price_for_parking(booking) do

    parking = Repo.get!(Parking, booking.data.parking_id)
    zone = Repo.get!(Zone, parking.zone_id)

    %{free_time: free_time, price_per_hour: price_per_hour, price_per_min: price_per_min} = zone
    %{inserted_at: inserted_at, payment_method: payment_method} = booking.data

    {:ok, inserted_at} = DateTime.from_naive(inserted_at, "Etc/UTC")
    now = Timex.now

    diff_in_minutes = Float.ceil DateTime.diff(now, inserted_at) / 60

    minutes_to_pay =
      cond do
        diff_in_minutes > free_time ->
          diff_in_minutes - free_time

        true ->
          0
      end

    price =
      case payment_method
        do
        "hourly" ->
          hours_to_pay = minutes_to_pay / 60
          Float.ceil(hours_to_pay, 0) * price_per_hour

        _ ->
          minutes_to_pay * price_per_min
      end

    {price, inserted_at, now}
  end

end