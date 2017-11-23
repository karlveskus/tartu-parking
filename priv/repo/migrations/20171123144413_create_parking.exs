defmodule TartuParking.Repo.Migrations.CreateParking do
  use Ecto.Migration

  def change do
   create table(:parkings) do
      add :address, :string
      add :available_slots, :string
      add :total_slots, :string

      timestamps()
    end
  end
end
