defmodule TartuParking.Closest do
    @http_client Application.get_env(:tartu_parking, :http_client)
    # ==============================
    # Given a list of taxi locations (origins), the followin function computes 
    # the duration of the trips to reach the pick up address (destination) 
    # specified by the customer in a booking request
    def distances_for(origins, destination) do
        origins = origins
            |> Enum.map(fn loc -> loc<>" Tartu Estonia" end) # Complete taxi location
            |> Enum.join("|") # Concatenate all the taxi locations with "|" as separator
        destination = destination <> " Tartu Estonia" # Complete pickup address
        url = URI.encode("http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{origins}&destinations=#{destination}")
        %{body: body} = @http_client.get!(url)

        # Parse the body of the HTTP response (JSON)
        %{"rows" => rows} = Poison.Parser.parse!(body) # We are interested only in the rows
        Enum.map(rows, fn row ->
            distance = Map.get(row, "elements") |> List.first |> Map.get("distance")
            {distance["text"], distance["value"]}  
        end)
    end
end