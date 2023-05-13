defmodule SchoolApp.Students do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database.Student
  alias Faker
  alias SchoolApp.QueryUtils
  alias SchoolApp.WebUtils
  use SchoolAppWeb, :verified_routes

  def list do
    qy = QueryUtils.query(Student, [:id, :name])
    Repo.all(qy)
  end

  def web_options_list do
    QueryUtils.query("students", [:id, :name])
    |> QueryUtils.sort(%{sort_by: :name, sort_order: :asc})
    |> Repo.all()
    |> WebUtils.select_list()
  end

  def app_item_config do
    %{
      id: :students,
      link: ~p"/students",
      icon: ["hero-user"],
      name: "Students",
      item_title: "Student",
      form_rec_id: "student",
      changeset_fn: &SchoolApp.Students.changeset(&1, &2),
      update_fn: &SchoolApp.Students.update(&1, &2),
      create_fn: &SchoolApp.Students.create(&1),
      delete_fn: &SchoolApp.Students.delete(&1),
      get_rec_fn: &SchoolApp.Students.get_record!(&1),
      list_records: &SchoolApp.Students.list/0,
      schema: %SchoolApp.Database.Student{},
      form_cols: [
        %{fieldname: :code, label: "Code"},
        %{fieldname: :name, label: "Name"}
      ]
    }
  end

  def get(id) do
    qy = QueryUtils.query_by_id(Student, id, [:id, :name])
    Repo.one(qy)
  end

  def list_records do
    Repo.all(Student)
  end

  def get_record!(id), do: Repo.get!(Student, id)

  def delete(%Student{} = record) do
    Repo.delete(record)
  end

  def create(attrs \\ %{}) do
    %Student{}
    |> Student.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Student{} = record, attrs) do
    record
    |> Student.changeset(attrs)
    |> Repo.update()
  end

  def changeset(%Student{} = record, attrs \\ %{}) do
    Student.changeset(record, attrs)
  end

  def create_student_fake(i) do
    create(%{
      code: "ST_#{String.pad_leading(Integer.to_string(i), 3, "0")}",
      name: "#{Faker.Person.En.first_name()} #{Faker.Person.En.last_name()}",
      avatar: Faker.Avatar.image_url(100, 100),
      grade_id: :rand.uniform(10) + 1
    })
  end
end
