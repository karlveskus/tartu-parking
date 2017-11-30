defmodule TartuParking.Geolocator do
	@http_client Application.get_env(:tartu_parking, :http_client)
	import Ecto.Query, only: [from: 2]
	alias TartuParking.{Repo,Parking}
	

	def find_closest_parkings(address) do

		# Maximum distance between inserted destination and parking places in meters
		max_distance = 500

		query = from p in Parking, where: p.available_slots > 0, select: p
		available_parkings = Repo.all(query)

		if length(available_parkings) == 0 do
			[]
		else
			# Join parking places for Distancematrix API
			joined_parking_addresses = 
			available_parkings
			|> Enum.map(fn(parking) -> parking.address <> " Tartu Estonia" end)
			|> Enum.join("|")

			# Google Distancematrix API request to get distances for all available parking places
			origin = address <> " Tartu Estonia" 
			
			url = URI.encode("http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{origin}&destinations=#{joined_parking_addresses}")

			# Parse distances
			%{"body": body} = @http_client.get!(url)
			%{"rows" => rows} = Poison.Parser.parse!(body)
			%{"elements" => distances} = List.first(rows)

			# Filter out only parkings in given range
			parkings_in_range = 
				Enum.zip(available_parkings, distances)
				|> Enum.filter(fn(parking) -> parking_is_in_range(parking, max_distance) end)

			parkings_in_range
		end
	end

	
	def parking_is_in_range({_parking, distance}, range) do
		# Checks if parking place distance is less than given range

		distance 
		|> Map.fetch("distance") 
		|> elem(1) 
		|> Map.fetch("value") 
		|> elem(1) < range
	end

end