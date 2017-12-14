defmodule TartuParking.ZoneAPIController do
  use TartuParking.Web, :controller
  alias TartuParking.{Repo, Zone}

  def index(conn, _params) do

    zones = Repo.all(Zone)

    conn
    |> put_status(200)
    |> json(zones)
  end

  def show(conn, %{"id" => zone_id}) do

    zone = Repo.get(Zone, zone_id)

    case zone do
      nil ->
        conn
        |> put_status(400)
        |> json(%{"message": "Zone not found"})

      _ ->
        conn
        |> put_status(200)
        |> json(zone)
    end

  end

end