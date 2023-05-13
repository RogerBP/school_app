defmodule SchoolApp.Database.Assessment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assessments" do
    belongs_to :student, SchoolApp.Database.Student
    belongs_to :teacher, SchoolApp.Database.Teacher
    belongs_to :goal, SchoolApp.Database.Goal
    belongs_to :domain, SchoolApp.Database.Domain
    belongs_to :class, SchoolApp.Database.Class
    belongs_to :grade, SchoolApp.Database.Grade
    field :value, :integer

    timestamps()
  end

  @doc false
  def changeset(assessment, attrs) do
    assessment
    |> cast(attrs, [
      :student_id,
      :teacher_id,
      :goal_id,
      :domain_id,
      :class_id,
      :grade_id,
      :value,
      :inserted_at
    ])
    |> validate_required([
      :student_id,
      :teacher_id,
      :goal_id,
      :domain_id,
      :grade_id,
      :value
    ])
  end
end
