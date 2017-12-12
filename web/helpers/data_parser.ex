defmodule TartuParking.DataParser do
  def get_coordinates_by_address(parking_data, address) do
    parking_data
    |> Enum.filter(
         fn (parking) ->
           Map.get(parking, "properties")
           |> Map.get("Name") == address
         end
       )
    |> List.first()
    |> Map.get("geometry")
    |> Map.get("coordinates")
    |> List.first
    |> Enum.map(fn ([x, y, z]) -> {x, y} end)
  end
end