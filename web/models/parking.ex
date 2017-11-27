defmodule TartuParking.Parking do
    use TartuParking.Web, :model
  
    schema "parkings" do
      field :address, :string
      field :available_slots, :string
      field :total_slots, :string
  
      timestamps()
    end
  
    @doc """
    Builds a changeset based on the `struct` and `params`.
    """
    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:address, :available_slots, :total_slots])
    end
  end
  