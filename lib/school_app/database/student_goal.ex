defmodule SchoolApp.Database.StudentGoal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "students_goals" do
    belongs_to :student, SchoolApp.Database.Student
    belongs_to :goal, SchoolApp.Database.Goal

    timestamps()
  end

  @doc false
  def changeset(student_goal, attrs) do
    student_goal
    |> cast(attrs, [:student_id, :goal_id])
    |> unique_constraint([:student_id, :goal_id], name: :students_goals_student_id_goal_id_index)
    |> validate_required([:student_id, :goal_id])
  end
end
