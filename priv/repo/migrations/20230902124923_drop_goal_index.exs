defmodule SchoolApp.Repo.Migrations.DropGoalIndex do
  use Ecto.Migration

  def change do
    drop_if_exists index("students_goals", [:student_id, :goal_id])
    drop_if_exists index("students_goals", [:goal_id, :student_id])

    create unique_index(:students_goals, [:student_id, :domain_id, :goal],
             name: :students_goals_domain_goal_index
           )

  end
end
