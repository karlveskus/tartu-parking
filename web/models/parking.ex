defmodule TartuParking.Parking do
    use TartuParking.Web, :model
    schema "parkings" do
      field :address, :string
      field :available_slots, :integer
      field :total_slots, :integer
      field :coordinates, Geo.MultiPoint
      field :distance, :float, virtual: true
      has_many :bookings, TartuParking.Booking
  
      timestamps()
    end
  
    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:address, :available_slots, :total_slots, :coordinates])
    end
    
    # Returns the parkings which are in the given radius near the given point
    def within(query, point, radius_in_m) do
      {lng, lat} = point.coordinates
      from(parking in query, where: fragment("ST_DWithin(?::geography, ST_SetSRID(ST_MakePoint(?, ?), ?), ?)", parking.coordinates, ^lng, ^lat, ^point.srid, ^radius_in_m))
    end

    # Orders all the polygons of the db by nearest from the given point
    def order_by_nearest(query, point) do
      {lng,lat} = point.coordinates
      from(parking in query, order_by: fragment("? <-> ST_SetSRID(ST_MakePoint(?,?), ?)", parking.coordinates, ^lng,^lat , ^point.srid))
    end

    # Return all the parkings with the distances between the polygons points and the given point
    def select_with_distance(query, point) do
      {lng,lat} = point.coordinates
      from(parking in query,
        select: %{parking | distance: fragment("ST_Distance_Sphere(?, ST_SetSRID(ST_MakePoint(?,?), ?))", parking.coordinates, ^lng, ^lat, ^point.srid)})
    end

    # Get closest point between a given point or polygon and the polygons from the db
    def get_closest_point(query, point) do
      from(parking in query,
        select: %{parking | closest_point: fragment("ST_ClosestPoint(?, ?)", parking.coordinates, ^point)})
    end

  end
  