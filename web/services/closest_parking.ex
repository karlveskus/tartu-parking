defmodule TartuParking.Closest do
    @http_client Application.get_env(:takso, :http_client)
    # ==============================
    # Given a list of taxi locations (origins), the followin function computes 
    # the duration of the trips to reach the pick up address (destination) 
    # specified by the customer in a booking request
    def durations_for(origins, destination) do
        origins = origins
            |> Enum.map(fn loc -> loc<>" Tartu Estonia" end) # Complete taxi location
            |> Enum.join("|") # Concatenate all the taxi locations with "|" as separator
        destination = destination <> " Tartu Estonia" # Complete pickup address
        url = URI.encode("http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{origins}&destinations=#{destination}")
        %{body: body} = @http_client.get!(url)

        # Parse the body of the HTTP response (JSON)
        %{"rows" => rows} = Poison.Parser.parse!(body) # We are interested only in the rows
        Enum.map(rows, fn row ->
            duration = Map.get(row, "elements") |> List.first |> Map.get("duration")
            {duration["text"], duration["value"]}  # We keep both duration as text (minutes) and also as value (secs)
        end)
    end

    def duration_for(origin, destination) do
        origin = origin <> " Tartu Estonia"
        destination = destination <> " Tartu Estonia"
        url = URI.encode("http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{origin}&destinations=#{destination}")
        %{body: body} = @http_client.get!(url)
        Regex.named_captures(~r/(?<duration_text>\d+ mins)/, body)
        |> Map.get("duration_text")
    end
end