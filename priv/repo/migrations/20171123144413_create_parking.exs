defmodule TartuParking.Repo.Migrations.CreateParking do
  use Ecto.Migration
  
  

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"
    create table(:parkings) do
      add :address, :string
      add :total_slots, :integer
      add :pin_lng, :float
      add :pin_lat, :float

      timestamps()
    end
    execute("SELECT AddGeometryColumn ('parkings','coordinates',4326,'MULTIPOINT',2);")
    # TODO add index using gist
  end
end
