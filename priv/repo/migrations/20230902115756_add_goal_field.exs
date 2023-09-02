defmodule SchoolApp.Repo.Migrations.AddGoalField do
  use Ecto.Migration

  def change do
    alter table(:students_goals) do
      add :goal, :string
      add :domain_id, references(:domains, on_delete: :nothing)
    end
    create index(:students_goals, [:domain_id])
  end
end
