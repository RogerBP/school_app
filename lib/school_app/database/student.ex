defmodule SchoolApp.Database.Student do
  use Ecto.Schema
  import Ecto.Changeset

  schema "students" do
    field :code, :string
    field :name, :string
    field :avatar, :string
    field :grade_id, :id

    timestamps()
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [:code, :name, :avatar, :grade_id])
    |> validate_required([:code, :name])
  end
end
