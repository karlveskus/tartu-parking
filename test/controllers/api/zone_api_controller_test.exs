defmodule TartuParking.ZoneAPIControllerTest do
  use TartuParking.ConnCase
  alias TartuParking.{Repo, Zone, User}

  describe "index/2" do
    setup [:add_zones, :login]

    test "Responds with all zones", %{conn: conn, zones: zones, jwt: jwt} do

      response =
        build_conn()
        |> put_req_header("authorization", jwt)
        |> get(zone_api_path(conn, :index))
        |> Map.get(:resp_body)
        |> Poison.Parser.parse!

      last_zone = Repo.all(Zone)
                  |> List.last()

      [_zone1, zone2] = zones

      assert length(response) >= 2
      assert zone2.name == last_zone.name

    end

  end

  describe "show/2" do
    setup [:add_zones, :login]

    test "Responds with zone if found", %{conn: conn, zones: zones, jwt: jwt} do

      zone_id = List.last(zones).id

      response =
        build_conn()
        |> put_req_header("authorization", jwt)
        |> get(zone_api_path(conn, :show, zone_id))
        |> Map.get(:resp_body)
        |> Poison.Parser.parse!

      assert Map.fetch!(response, "id") == zone_id

    end

    test "Responds with error message if zone was not found", %{conn: conn, zones: zones, jwt: jwt} do

      zone_id = List.last(zones).id

      response =
        build_conn()
        |> put_req_header("authorization", jwt)
        |> get(zone_api_path(conn, :show, zone_id + 1))
        |> Map.get(:resp_body)
        |> Poison.Parser.parse!

      assert Map.fetch!(response, "message") == "Zone not found"

    end

  end

  defp add_zones(_) do
    zones =
      [
        %{name: "Zone A", price_per_hour: 2.0, price_per_min: 0.12, free_time: 15},
        %{name: "Zone B", price_per_hour: 1.0, price_per_min: 0.08, free_time: 90}
      ]
      |> Enum.map(fn zone -> Zone.changeset(%Zone{}, zone) end)
      |> Enum.map(fn changeset -> Repo.insert!(changeset) end)

    {:ok, zones: zones}
  end

  defp login(_) do
    Repo.insert!(User.changeset(%User{}, %{name: "user", username: "username", password: "password"}))

    jwt =
      build_conn()
      |> post(session_api_path(build_conn(), :create), %{username: "username", password: "password"})
      |> Map.get(:resp_body)
      |> Poison.Parser.parse!
      |> Map.fetch!("token")

    {:ok, jwt: jwt}
  end

end