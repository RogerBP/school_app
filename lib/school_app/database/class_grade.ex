defmodule SchoolApp.Database.ClassGrade do
  use Ecto.Schema
  import Ecto.Changeset

  schema "classes_grades" do
    field :class_id, :id
    field :grade_id, :id

    timestamps()
  end

  @doc false
  def changeset(class_grade, attrs) do
    class_grade
    |> cast(attrs, [:class_id, :grade_id])
    |> validate_required([:class_id, :grade_id])
  end
end
