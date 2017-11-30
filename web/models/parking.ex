defmodule TartuParking.Parking do
    use TartuParking.Web, :model
    schema "parkings" do
      field :address, :string
      field :available_slots, :integer
      field :total_slots, :integer
      field :point, Geo.Geometry
      timestamps()
    end
  
    @doc """
    Builds a changeset based on the `struct` and `params`.
    """

   

    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:address, :available_slots, :total_slots, :point])
    end

    def within(query, point, radius_in_m) do
      {lng, lat} = point.coordinates
      from(parking in query, where: fragment("ST_DWithin(?::geography, ST_SetSRID(ST_MakePoint(?, ?), ?), ?)", parking.point, ^lng, ^lat, ^point.srid, ^radius_in_m))
    end
  
    def order_by_nearest(query, point) do
      {lng, lat} = point.coordinates
      from(parking in query, order_by: fragment("? <-> ST_SetSRID(ST_MakePoint(?,?), ?)", parking.point, ^lng, ^lat, ^point.srid))
    end
  
    def select_with_distance(query, point) do
      {lng, lat} = point.coordinates
      from(parking in query,
           select: %{parking | distance: fragment("ST_Distance_Sphere(?, ST_SetSRID(ST_MakePoint(?,?), ?))", parking.point, ^lng, ^lat, ^point.srid)})
    end
  end
  