defmodule TartuParking.User do
  use TartuParking.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :username, :password])
    |> validate_required([:name, :username, :password])
  end
end
