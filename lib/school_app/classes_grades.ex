defmodule SchoolApp.ClassesGrades do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database.ClassGrade

  def list do
    Repo.all(ClassGrade)
  end

  def create_class_grade(attrs \\ %{}) do
    %ClassGrade{}
    |> ClassGrade.changeset(attrs)
    |> Repo.insert()
  end
end
