defmodule TartuParking.Booking do
  use TartuParking.Web, :model
  @derive {Poison.Encoder, only: [:id, :status, :user_id, :parking_id]}

  schema "bookings" do
    field :status, :string
    belongs_to :user, TartuParking.User, foreign_key: :user_id
    belongs_to :parking, TartuParking.Parking, foreign_key: :parking_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :user_id, :parking_id])
    |> validate_required([:status, :user_id, :parking_id])
  end
end
