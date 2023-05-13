defmodule SchoolApp.Database.StudentDomain do
  use Ecto.Schema
  import Ecto.Changeset

  schema "students_domains" do
    belongs_to :student, SchoolApp.Database.Student
    belongs_to :domain, SchoolApp.Database.Domain

    timestamps()
  end

  @doc false
  def changeset(student_domain, attrs) do
    student_domain
    |> cast(attrs, [:student_id, :domain_id])
    |> validate_required([:student_id, :domain_id])
  end
end
