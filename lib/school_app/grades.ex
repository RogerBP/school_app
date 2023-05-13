defmodule SchoolApp.Grades do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database.Grade
  alias SchoolApp.QueryUtils
  use SchoolAppWeb, :verified_routes

  def list do
    qy = QueryUtils.query(Grade, [:id, :name])
    Repo.all(qy)
  end

  def web_options_list do
    SchoolApp.DbWeb.get_select_list_from("grades")
  end

  def app_item_config do
    %{
      id: :grades,
      link: ~p"/grades",
      icon: ["hero-book-open"],
      name: "Grades",
      item_title: "Grade",
      form_rec_id: "grade",
      changeset_fn: &SchoolApp.Grades.changeset(&1, &2),
      update_fn: &SchoolApp.Grades.update(&1, &2),
      create_fn: &SchoolApp.Grades.create(&1),
      delete_fn: &SchoolApp.Grades.delete(&1),
      get_rec_fn: &SchoolApp.Grades.get_record!(&1),
      list_records: &SchoolApp.Grades.list/0,
      schema: %SchoolApp.Database.Grade{}
    }
  end

  def get(id) do
    qy = QueryUtils.query_by_id(Grade, id, [:id, :name])
    Repo.one(qy)
  end

  def list_records do
    Repo.all(Grade)
  end

  def get_record!(id), do: Repo.get!(Grade, id)

  def delete(%Grade{} = record) do
    Repo.delete(record)
  end

  def create(attrs \\ %{}) do
    %Grade{}
    |> Grade.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Grade{} = record, attrs) do
    record
    |> Grade.changeset(attrs)
    |> Repo.update()
  end

  def changeset(%Grade{} = record, attrs \\ %{}) do
    Grade.changeset(record, attrs)
  end
end
