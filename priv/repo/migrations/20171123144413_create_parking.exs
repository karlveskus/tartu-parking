defmodule TartuParking.Repo.Migrations.CreateParking do
  use Ecto.Migration
  
  

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"
    create table(:parkings) do
      add :address, :string
      add :available_slots, :integer
      add :total_slots, :integer
    
      timestamps()
    end
    execute("SELECT AddGeometryColumn ('parkings','coordinates',4326,'MULTIPOINT',2);")
    # TODO add index using gist
  end
end
