defmodule TartuParking.Zone do
  use TartuParking.Web, :model
  @derive {Poison.Encoder, only: [:id, :name, :price_per_hour, :price_per_min, :free_time]}

  schema "zones" do
    field :name, :string
    has_many :parkings, TartuParking.Parking
    field :price_per_hour, :float
    field :price_per_min, :float
    field :free_time, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :price_per_hour, :price_per_min, :free_time])
    #|> validate_required([:id, :name])
  end
end
