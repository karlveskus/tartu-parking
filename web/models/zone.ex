defmodule TartuParking.Zone do
  use TartuParking.Web, :model

  schema "zones" do
    field :name, :string
    has_many :parkings, TartuParking.Parking

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
