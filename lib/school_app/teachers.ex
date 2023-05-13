defmodule SchoolApp.Teachers do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database.Teacher
  alias SchoolApp.QueryUtils
  use SchoolAppWeb, :verified_routes

  def list() do
    qy =
      QueryUtils.query(Teacher, [:id, :name])
      |> QueryUtils.sort(%{sort_by: :name, sort_order: :asc})
      |> QueryUtils.paginate(%{page: 1, per_page: 5})

    Repo.all(qy)
  end

  def web_options_list do
    QueryUtils.query("teachers", [:id, :name])
    |> QueryUtils.sort(%{sort_by: :name, sort_order: :asc})
    |> Repo.all()
    |> SchoolApp.WebUtils.select_list()
  end

  def app_item_config do
    %{
      id: :teachers,
      link: ~p"/teachers",
      icon: ["hero-user-group"],
      name: "Teachers",
      item_title: "Teacher",
      form_rec_id: "teacher",
      changeset_fn: &SchoolApp.Teachers.changeset(&1, &2),
      update_fn: &SchoolApp.Teachers.update(&1, &2),
      create_fn: &SchoolApp.Teachers.create(&1),
      delete_fn: &SchoolApp.Teachers.delete(&1),
      get_rec_fn: &SchoolApp.Teachers.get_record!(&1),
      list_records: &SchoolApp.Teachers.list/0,
      schema: %SchoolApp.Database.Teacher{},
      form_cols: [
        %{
          fieldname: :name,
          label: "Name"
        },
        %{
          fieldname: :job_id,
          label: "Job",
          type: "select",
          options_fn: &SchoolApp.Jobs.web_options_list/0
        }
      ]
    }
  end

  def get(id) do
    qy = QueryUtils.query_by_id(Teacher, id, [:id, :name])
    Repo.one(qy)
  end

  def list_records do
    Repo.all(Teacher)
  end

  def get_record!(id), do: Repo.get!(Teacher, id)

  def delete(%Teacher{} = record) do
    Repo.delete(record)
  end

  def create(attrs \\ %{}) do
    %Teacher{}
    |> Teacher.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Teacher{} = record, attrs) do
    record
    |> Teacher.changeset(attrs)
    |> Repo.update()
  end

  def changeset(%Teacher{} = record, attrs \\ %{}) do
    Teacher.changeset(record, attrs)
  end
end
