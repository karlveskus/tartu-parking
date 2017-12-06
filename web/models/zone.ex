defmodule TartuParking.Zone do
  use TartuParking.Web, :model

  schema "zones" do
    field :id, :string
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :name])
    |> validate_required([:id, :name])
  end
end
