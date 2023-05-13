defmodule SchoolApp.StudentsDomains do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database.StudentDomain
  use SchoolAppWeb, :verified_routes

  def app_item_config do
    %{
      id: :students_domains,
      # link: ~p"/students_domains",
      icon: ["hero-user", "hero-square-3-stack-3d"],
      name: "Students / Domains",
      item_title: "",
      form_rec_id: "student_domain",
      changeset_fn: &changeset(&1, &2),
      update_fn: &update_record(&1, &2),
      create_fn: &create(&1),
      delete_fn: &delete(&1),
      get_rec_fn: &get_record!(&1),
      list_records: &list/0,
      schema: %StudentDomain{},
      index_list_base: &index_list_base/0,
      index_cols: [:domain_name],
      edit_kind: :uneditable,
      form_cols: [
        %{
          fieldname: :domain_id,
          label: "Domain",
          type: "select",
          options_fn: &SchoolApp.Domains.web_options_list/0
        }
      ]
    }
  end

  def list do
    Repo.all(StudentDomain)
  end

  def create_student_domain(attrs \\ %{}) do
    %StudentDomain{}
    |> StudentDomain.changeset(attrs)
    |> Repo.insert()
  end

  def changeset(%StudentDomain{} = record, attrs \\ %{}) do
    StudentDomain.changeset(record, attrs)
  end

  def update_record(%StudentDomain{} = record, attrs) do
    record
    |> StudentDomain.changeset(attrs)
    |> Repo.update()
  end

  def create(attrs \\ %{}) do
    %StudentDomain{}
    |> StudentDomain.changeset(attrs)
    |> Repo.insert()
  end

  def delete(%StudentDomain{} = record) do
    Repo.delete(record)
  end

  def get_record!(id), do: Repo.get!(StudentDomain, id)

  def index_list_base do
    from students_domains in "students_domains",
      join: domains in "domains",
      on: students_domains.domain_id == domains.id,
      select: %{
        id: students_domains.id,
        student_id: students_domains.student_id,
        domain_id: students_domains.domain_id,
        domain_name: domains.name
      }
  end
end
