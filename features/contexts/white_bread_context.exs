defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers
  alias TartuParking.{Repo,Parking}

  feature_starting_state fn  ->
    Application.ensure_all_started(:hound)
    %{}
  end
  scenario_starting_state fn _state ->
    Hound.start_session
    %{}
  end
  scenario_finalize fn _status, _state ->
    # Hound.end_session
    nil
  end

  # Choosing place via mobile phone (with available places)

  given_ ~r/^the following parking places are in the area$/,
  fn state, %{table_data: table} ->
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
    fill_field({:id, "address_field"}, state[:address])
    {:ok, state}
  end

  when_ ~r/^I submit the request$/, fn state ->
    click({:id, "search_button"})
    {:ok, state}
  end

  then_ ~r/^Map with parkings places should be displayed$/, fn state ->
    assert visible_in_page? ~r/\d+ available parkings fount in your area/
    {:ok, state}
  end

  # Choosing place via mobile phone (with no parking places)

  then_ ~r/^I should receive a rejection message$/, fn state ->
    assert visible_in_page? ~r/No available parkings found in your area/
    {:ok, state}
  end
end
