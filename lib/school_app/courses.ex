defmodule SchoolApp.Courses do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database.Course
  alias SchoolApp.QueryUtils
  alias SchoolApp.DbWeb
  use SchoolAppWeb, :verified_routes

  def app_item_config do
    %{
      id: :courses,
      link: ~p"/courses",
      icon: ["hero-academic-cap"],
      name: "Courses",
      item_title: "Course",
      form_rec_id: "course",
      changeset_fn: &SchoolApp.Courses.changeset(&1, &2),
      update_fn: &SchoolApp.Courses.update(&1, &2),
      create_fn: &SchoolApp.Courses.create(&1),
      delete_fn: &SchoolApp.Courses.delete(&1),
      get_rec_fn: &SchoolApp.Courses.get_record!(&1),
      list_records: &SchoolApp.Courses.list/0,
      schema: %SchoolApp.Database.Course{}
    }
  end

  def list do
    qy = QueryUtils.query(Course, [:id, :name])
    Repo.all(qy)
  end

  def web_options_list do
    DbWeb.get_select_list_from("courses")
  end

  def get(id) do
    qy = QueryUtils.query_by_id(Course, id, [:id, :name])
    Repo.one(qy)
  end

  def list_records do
    Repo.all(Course)
  end

  def get_record!(id), do: Repo.get!(Course, id)

  def delete(%Course{} = record) do
    Repo.delete(record)
  end

  def create(attrs \\ %{}) do
    %Course{}
    |> Course.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Course{} = record, attrs) do
    record
    |> Course.changeset(attrs)
    |> Repo.update()
  end

  def changeset(%Course{} = record, attrs \\ %{}) do
    Course.changeset(record, attrs)
  end
end
