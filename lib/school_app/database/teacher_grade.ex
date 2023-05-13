defmodule SchoolApp.Database.TeacherGrade do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teachers_grades" do
    belongs_to :teacher, SchoolApp.Database.Teacher
    belongs_to :grade, SchoolApp.Database.Grade

    timestamps()
  end

  @doc false
  def changeset(teacher_class, attrs) do
    teacher_class
    |> cast(attrs, [:grade_id, :teacher_id])
    |> validate_required([:grade_id, :teacher_id])
    |> unique_constraint([:grade_id, :teacher_id])
  end
end
