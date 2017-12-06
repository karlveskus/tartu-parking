defmodule TartuParking.Zone do
  use TartuParking.Web, :model

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
    |> cast(params, [:name])
    #|> validate_required([:id, :name])
  end
end
