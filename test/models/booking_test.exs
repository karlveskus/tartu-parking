defmodule TartuParking.BookingTest do
  use TartuParking.ModelCase

  alias TartuParking.Booking

  @valid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Booking.changeset(%Booking{}, @valid_attrs)
    assert changeset.valid?
  end
  
end
