defmodule TartuParking.UserTest do
  use TartuParking.ModelCase

  alias TartuParking.User

  @valid_attrs %{name: "some name", password: "some password", username: "some username"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
