defmodule TartuParking.User do
  use TartuParking.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    has_many :bookings, TartuParking.Booking

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :username, :password])
    |> validate_required([:name, :username, :password])
    |> encrypt_password
  end

  def encrypt_password(changeset) do
    if changeset.valid? do
      IO.inspect(changeset)
      put_change(changeset, :encrypted_password, Comeonin.Pbkdf2.hashpwsalt(changeset.changes[:password]))
    else
      changeset
    end
  end
end
