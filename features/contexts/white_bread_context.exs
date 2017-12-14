defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers
  alias TartuParking.{Repo,Parking,DataParser}
  alias Ecto.{Changeset}

  feature_starting_state fn  ->
    Application.ensure_all_started(:hound)
    %{}
  end
  scenario_starting_state fn _state ->
    Hound.start_session
    Ecto.Adapters.SQL.Sandbox.checkout(TartuParking.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(TartuParking.Repo, {:shared, self()})
    %{}
  end
  scenario_finalize fn _status, _state ->
    Ecto.Adapters.SQL.Sandbox.checkin(TartuParking.Repo)
    #Hound.end_session
  end

  # Choosing place via mobile phone (with available places)

  given_ ~r/^the following parking places are in the area$/,
  fn state, %{table_data: table} ->
  
    table = Enum.map(table, fn parking -> 
      coord =
        String.split(parking.coordinates, ["?"]) 
        |> Enum.map(fn i -> String.replace(i, "{","") 
        |> String.replace("}","") 
        |> String.replace("[","") 
        |> String.replace("]","") 
        |> String.split(",")end) 
        |> Enum.map(fn x -> Enum.map(x, fn z-> Float.parse(String.trim(z)) |> elem(0)end) end)
        |> Enum.map(fn x -> List.to_tuple(x)end)
      
      pin_lat = DataParser.get_coordinates_by_address(parking.address) |> Map.get("lat")
      pin_lng = DataParser.get_coordinates_by_address(parking.address) |> Map.get("lng")
      parking = Map.put(parking, :pin_lat, pin_lat)
      parking = Map.put(parking, :pin_lng, pin_lng)
      parking|> Map.drop([:coordinates])
      Map.put(parking, :coordinates, %Geo.MultiPoint{coordinates: coord, srid: 4326}) 
  end) 
  
    table
    |> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
    {:ok, state}
  end

  and_ ~r/^I want to park vehicle to "(?<address>[^"]+)"$/,
  fn state, %{address: address} ->
    {:ok, state |> Map.put(:address, address)}
  end

  and_ ~r/^I open FindMeParking mobile application$/, fn state ->
    navigate_to "/"
    {:ok, state}
  end

  and_ ~r/^I enter the destination address$/, fn state ->
    fill_field({:id, "address-field"}, state[:address])
    {:ok, state}
  end

  when_ ~r/^I submit the request$/, fn state ->
    click({:id, "search-button"})
    {:ok, state}
  end

  then_ ~r/^Map with parking places should be displayed$/, fn state ->
    :timer.sleep(2000) # Wait for api response

    # Seems like it's the only way to test if markers exist or not
    # is to check amount of canvases created by google-maps
    canvas = find_all_elements(:tag, "canvas")
    
    assert length(canvas) >= 2
    {:ok, state}
  end

  when_ ~r/^I log in$/, fn state ->
    click({:id, "log-in-button"})
    fill_field({:id, "username"},"user")
    fill_field({:id, "password"},"user")
    :timer.sleep(1000)
    click({:id, "log-in-button"})
    {:ok, state}
  end

  and_ ~r/^I go to bookings page$/, fn state ->
    :timer.sleep(1000)
    navigate_to "/bookings?parking_id=1"
    {:ok, state}
  end
  when_ ~r/^I click Book a spot$/, fn state ->
    click({:id, "book-parking"})
    :timer.sleep(1000)
    {:ok, state}
  end
 
end
