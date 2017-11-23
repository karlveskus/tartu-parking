defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers

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
  end

  # Choosing place via mobile phone (with available places)

  given_ ~r/^the following parking places are in the area$/, fn state ->
    {:ok, state}
  end

  and_ ~r/^I want to park vehicle to "(?<argument_one>[^"]+)"$/,
  fn state, %{argument_one: _argument_one} ->
    {:ok, state}
  end

  and_ ~r/^I open FindMeParking mobile application$/, fn state ->
    {:ok, state}
  end

  and_ ~r/^I enter the destination address$/, fn state ->
    {:ok, state}
  end

  when_ ~r/^I submit the request$/, fn state ->
    {:ok, state}
  end

  then_ ~r/^Map with parkings places should be displayed$/, fn state ->
    {:ok, state}
  end

  # Choosing place via mobile phone (with no parking places)

  then_ ~r/^Map should be displayed with “there are  no available parking places”$/, fn state ->
    {:ok, state}
  end
end
