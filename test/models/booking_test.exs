defmodule TartuParking.BookingTest do
  use TartuParking.ModelCase

  alias TartuParking.Booking

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Booking.changeset(%Booking{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Booking.changeset(%Booking{}, @invalid_attrs)
    refute changeset.valid?
  end
end
