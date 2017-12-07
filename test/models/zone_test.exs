defmodule TartuParking.ZoneTest do
  use TartuParking.ModelCase

  alias TartuParking.Zone

  @valid_attrs %{id: "some id", name: "some name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Zone.changeset(%Zone{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Zone.changeset(%Zone{}, @invalid_attrs)
    refute changeset.valid?
  end
end
