defmodule SchoolApp.Database.Domain do
  use Ecto.Schema
  import Ecto.Changeset

  schema "domains" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(domain, attrs) do
    domain
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
