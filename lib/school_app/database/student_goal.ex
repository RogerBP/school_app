defmodule SchoolApp.Database.StudentGoal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "students_goals" do
    field :goal, :string
    belongs_to :student, SchoolApp.Database.Student
    belongs_to :domain, SchoolApp.Database.Domain
    # belongs_to :goal, SchoolApp.Database.Goal

    timestamps()
  end

  @doc false
  def changeset(student_goal, attrs) do
    student_goal
    |> cast(attrs, [:goal, :student_id, :domain_id])
    |> unique_constraint([:student_id, :domain_id, :goal], name: :students_goals_domain_goal_index)
    |> validate_required([:student_id, :domain_id, :goal])
  end
end
