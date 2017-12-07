defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers
  alias TartuParking.{Repo,Parking}
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
    :timer.sleep(1000)
    fill_field({:id, "address-field"}, state[:address])
    {:ok, state}
  end

  when_ ~r/^I submit the request$/, fn state ->
    :timer.sleep(1000)
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

  # Choosing place via mobile phone (with no parking places)

  then_ ~r/^Map with no parking places should be displayed$/, fn state ->
    # navigate_to "/"
    # fill_field({:id, "address-field"}, state[:address])
    # click({:id, "search-button"})
    :timer.sleep(2000) # Wait for api response

    # Seems like it's the only way to test if markers exist or not
    # is to check amount of canvases created by google-maps
    canvas = find_all_elements(:tag, "canvas")

    assert length(canvas) == 1
    {:ok, state}
  end
end
