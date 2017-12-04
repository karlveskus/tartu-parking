defmodule TartuParking.Booking do
  use TartuParking.Web, :model

  schema "bookings" do
    belongs_to :user, TartuParking.User, foreign_key: :user_id
    belongs_to :parking, TartuParking.Parking, foreign_key: :parking_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
