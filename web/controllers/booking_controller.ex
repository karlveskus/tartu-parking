defmodule TartuParking.BookingController do
  use TartuParking.Web, :controller
  alias TartuParking.{Repo, Parking, Zone, ParkingAPIController}

  def index(conn, params) do

    parking =
      case Map.fetch(params, "parking_id") do
        :error ->
          ""

        {:ok, parking_id} ->
          Repo.get(Parking, parking_id)
          |> ParkingAPIController.format_parking()
          |> Poison.encode!
      end

      IO.inspect parking


    render conn, "index.html", parking_data: parking

  end

end
  