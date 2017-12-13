defmodule TartuParking.DataParser do
  @http_client Application.get_env(:tartu_parking, :http_client)

  def get_coordinates_by_address(address) do
    url = URI.encode(
      "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBQek7NQLBPy99BvR8O9Z1SPzCs9OasrSo&address=#{
        address
      },+Tartu+city,+Estonia"
    )

    %{"body": body} = @http_client.get!(url)
    %{"results" => results} = Poison.Parser.parse!(body)
    %{"geometry" => geometry} = List.first(results)
    %{"location" => location} = geometry
    location
  end

  def get_coordinates_by_address(address, parking_data) do
    parking_data
    |> Enum.filter(
         fn (parking) ->
           Map.get(parking, "properties")
           |> Map.get("name") == address
         end
       )
    |> List.first()
    |> Map.get("geometry")
    |> Map.get("coordinates")
    |> List.first
    |> Enum.map(fn ([x, y, z]) -> {x, y} end)
  end
end