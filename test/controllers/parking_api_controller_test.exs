defmodule TartuParking.ParkingAPIControllerTest do
  use TartuParking.ConnCase
  alias TartuParking.{Repo,Parking}

  describe "index/2" do

    test "Has 2 of 3 total parkings available and returns closest parking places", %{conn: conn} do
      [%{address: "Liivi 1", available_slots: 0, total_slots: 10},
        %{address: "Liivi 4", available_slots: 10, total_slots: 20},
        %{address: "Liivi 8", available_slots: 10, total_slots: 20}]
      |> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
      |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
      
      response = build_conn
      |> get(parking_api_path(conn, :index), address: "Liivi 2")
      |> Map.get(:resp_body)
      |> Poison.Parser.parse!
  
      assert length(response) == 2
      assert Map.get(List.first(response), "address") == "Liivi 4"
      assert Map.get(List.last(response), "address") == "Liivi 8"
    end

    test "Has 0 parkings available and returns emptly list", %{conn: conn} do
      [%{address: "Liivi 2", available_slots: 0, total_slots: 10}]
      |> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
      |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
      
      response = build_conn
      |> get(parking_api_path(conn, :index), address: "Liivi 2")
      |> Map.get(:resp_body)
      |> Poison.Parser.parse!
  
      assert length(response) == 0
    end

  end

end
