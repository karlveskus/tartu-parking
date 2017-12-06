defmodule TartuParking.Repo.Migrations.AddChangesToParking do
  use Ecto.Migration

  def change do
    alter table(:parkings) do
      add :zone_id, references(:zones)
    end
  end
end
