defmodule TartuParking.Repo.Migrations.CreateZone do
  use Ecto.Migration

  def change do
    create table(:zones) do
      add :name, :string
      add :price_per_hour, :float
      add :price_per_min, :float
      add :free_time, :integer
      
      timestamps()
    end
  end
end
