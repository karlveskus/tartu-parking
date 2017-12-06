defmodule TartuParking.Repo.Migrations.AddChangesToZone do
  use Ecto.Migration

  def change do
    alter table(:zones) do
      add :price_per_hour, :float
      add :price_per_min, :float
      add :free_time, :integer
    end
  end
end
