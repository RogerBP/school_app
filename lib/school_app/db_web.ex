defmodule SchoolApp.DbWeb do
  alias SchoolApp.WebUtils
  alias SchoolApp.QueryUtils
  alias SchoolApp.Repo

  def get_select_list_from(table) do
    QueryUtils.query(table, [:id, :name])
    |> Repo.all()
    |> WebUtils.select_list()
  end

  def teacher_list do
    SchoolApp.Db.teacher_list()
    |> WebUtils.select_list()
  end

  def grade_list_by_teacher(teacher_id) do
    SchoolApp.Db.grades_by_teacher(teacher_id)
    |> WebUtils.select_list()
  end

  def class_list_by_teacher(teacher_id) do
    SchoolApp.Db.classes_by_teacher(teacher_id)
    |> Enum.map(&%{name: &1.code, id: &1.id})
    |> WebUtils.select_list()
  end
end
