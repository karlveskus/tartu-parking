defmodule TartuParking.BookingTest do
  use TartuParking.ModelCase

  alias TartuParking.Booking

  @invalid_attrs %{}

  test "changeset with invalid attributes" do
    changeset = Booking.changeset(%Booking{}, @invalid_attrs)
    refute changeset.valid?
  end

end
