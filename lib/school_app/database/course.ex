defmodule SchoolApp.Database.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
