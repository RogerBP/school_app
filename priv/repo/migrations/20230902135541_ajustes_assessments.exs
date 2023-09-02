defmodule SchoolApp.Repo.Migrations.AjustesAssessments do
  use Ecto.Migration

  def change do
    alter table(:assessments) do
      add :student_goal_id, references(:students_goals, on_delete: :nothing)
    end

    create index(:assessments, [:student_goal_id])
  end
end
