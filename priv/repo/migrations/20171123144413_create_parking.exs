defmodule TartuParking.Repo.Migrations.CreateParking do
  use Ecto.Migration

  def change do
   create table(:parkings) do
      add :address, :string
      add :available_slots, :integer
      add :total_slots, :integer

      timestamps()
    end
  end
end
