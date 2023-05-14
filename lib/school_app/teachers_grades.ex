defmodule SchoolApp.TeachersGrades do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.QueryUtils
  alias SchoolApp.Database.TeacherGrade
  use SchoolAppWeb, :verified_routes

  def app_item_config do
    %{
      id: :teachers_grades,
      link: ~p"/teachers_grades",
      icon: ["hero-user-group", "hero-book-open"],
      name: "Teachers / Grades",
      item_title: "",
      form_rec_id: "teacher_grade",
      changeset_fn: &changeset(&1, &2),
      update_fn: &update_record(&1, &2),
      create_fn: &create(&1),
      delete_fn: &delete(&1),
      get_rec_fn: &get_record!(&1),
      schema: %SchoolApp.Database.TeacherGrade{},
      index_list_base: &index_list_base/0,
      index_cols: [:grade_name],
      edit_kind: :uneditable,
      form_cols: [
        %{
          fieldname: :grade_id,
          label: "Grade",
          type: "select",
          options_fn: &SchoolApp.Grades.web_options_list/0
        }
      ]
    }
  end

  def list(filter) do
    QueryUtils.filter(TeacherGrade, filter)
    |> Repo.all()
  end

  def load_grades(list) do
    Repo.preload(list, [:grade])
  end

  def create_teacher_grade(attrs \\ %{}) do
    %TeacherGrade{}
    |> TeacherGrade.changeset(attrs)
    |> Repo.insert()
  end

  def changeset(%TeacherGrade{} = record, attrs \\ %{}) do
    TeacherGrade.changeset(record, attrs)
  end

  def update_record(%TeacherGrade{} = record, attrs) do
    record
    |> TeacherGrade.changeset(attrs)
    |> Repo.update()
  end

  def create(attrs \\ %{}) do
    %TeacherGrade{}
    |> TeacherGrade.changeset(attrs)
    |> Repo.insert()
  end

  def delete(%TeacherGrade{} = record) do
    Repo.delete(record)
  end

  def get_record!(id), do: Repo.get!(TeacherGrade, id)

  def index_list_base do
    from teachers_grades in "teachers_grades",
      join: grades in "grades",
      on: teachers_grades.grade_id == grades.id,
      select: %{
        id: teachers_grades.id,
        teacher_id: teachers_grades.teacher_id,
        grade_id: teachers_grades.grade_id,
        grade_name: grades.name
      }
  end
end
