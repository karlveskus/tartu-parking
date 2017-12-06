defmodule TartuParking.Repo.Migrations.CreateZone do
  use Ecto.Migration

  def change do
    create table(:zones) do
      add :name, :string

      timestamps()
    end
  end
end
