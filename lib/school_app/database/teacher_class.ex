defmodule SchoolApp.Database.TeacherClass do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teachers_classes" do
    belongs_to :class, SchoolApp.Database.Class
    belongs_to :teacher, SchoolApp.Database.Teacher

    timestamps()
  end

  @doc false
  def changeset(teacher_class, attrs) do
    teacher_class
    |> cast(attrs, [:class_id, :teacher_id])
    |> validate_required([:class_id, :teacher_id])
  end
end
