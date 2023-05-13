defmodule SchoolApp.Database.School do
  use Ecto.Schema
  import Ecto.Changeset
  # alias SchoolApp.Database.District

  schema "schools" do
    field :name, :string
    field :district_id, :id

    # belongs_to :district, District
    timestamps()
  end

  @doc false
  def changeset(school, attrs) do
    school
    |> cast(attrs, [:name, :district_id])
    |> validate_required([:name, :district_id])
  end
end
