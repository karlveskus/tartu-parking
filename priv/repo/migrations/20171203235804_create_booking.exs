defmodule TartuParking.Repo.Migrations.CreateBooking do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :user_id, references(:users)
      add :parking_id, references(:parkings)
      add :status, :string

      timestamps()
    end

    create index(:bookings, [:user_id])
    create index(:bookings, [:parking_id])
  end
end
