defmodule SchoolApp.Repo.Migrations.AddTeacherJob do
  use Ecto.Migration

  def change do
    alter table("teachers") do
      add :job_id, references(:jobs, on_delete: :nothing)
    end

    create index(:teachers, [:job_id])
  end
end
