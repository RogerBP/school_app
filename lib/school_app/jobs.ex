defmodule SchoolApp.Jobs do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database.Job
  alias SchoolApp.QueryUtils
  alias SchoolApp.DbWeb
  use SchoolAppWeb, :verified_routes

  def list do
    qy = QueryUtils.query(Job, [:id, :name])
    Repo.all(qy)
  end

  def web_options_list do
    DbWeb.get_select_list_from("jobs")
  end

  def app_item_config do
    %{
      id: :jobs,
      link: ~p"/jobs",
      icon: ["hero-briefcase"],
      name: "Jobs",
      item_title: "Job",
      form_rec_id: "job",
      changeset_fn: &SchoolApp.Jobs.changeset(&1, &2),
      update_fn: &SchoolApp.Jobs.update(&1, &2),
      create_fn: &SchoolApp.Jobs.create(&1),
      delete_fn: &SchoolApp.Jobs.delete(&1),
      get_rec_fn: &SchoolApp.Jobs.get_record!(&1),
      list_records: &SchoolApp.Jobs.list/0,
      schema: %SchoolApp.Database.Job{}
    }
  end

  def get(id) do
    qy = QueryUtils.query_by_id(Job, id, [:id, :name])
    Repo.one(qy)
  end

  def list_records do
    Repo.all(Job)
  end

  def get_record!(id), do: Repo.get!(Job, id)

  def delete(%Job{} = record) do
    Repo.delete(record)
  end

  def create(attrs \\ %{}) do
    %Job{}
    |> Job.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Job{} = record, attrs) do
    record
    |> Job.changeset(attrs)
    |> Repo.update()
  end

  def changeset(%Job{} = record, attrs \\ %{}) do
    Job.changeset(record, attrs)
  end
end
