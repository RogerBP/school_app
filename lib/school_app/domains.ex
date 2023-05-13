defmodule SchoolApp.Domains do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database.Domain
  alias SchoolApp.QueryUtils
  alias SchoolApp.DbWeb
  use SchoolAppWeb, :verified_routes

  def list do
    qy = QueryUtils.query(Domain, [:id, :name])
    Repo.all(qy)
  end

  def web_options_list do
    DbWeb.get_select_list_from("domains")
  end

  def app_item_config do
    %{
      id: :domains,
      link: ~p"/domains",
      icon: ["hero-square-3-stack-3d"],
      name: "Domains",
      item_title: "Domain",
      form_rec_id: "domain",
      changeset_fn: &SchoolApp.Domains.changeset(&1, &2),
      update_fn: &SchoolApp.Domains.update(&1, &2),
      create_fn: &SchoolApp.Domains.create(&1),
      delete_fn: &SchoolApp.Domains.delete(&1),
      get_rec_fn: &SchoolApp.Domains.get_record!(&1),
      list_records: &SchoolApp.Domains.list/0,
      schema: %SchoolApp.Database.Domain{}
    }
  end

  def get(id) do
    qy = QueryUtils.query_by_id(Domain, id, [:id, :name])
    Repo.one(qy)
  end

  def list_records do
    Repo.all(Domain)
  end

  def get_record!(id), do: Repo.get!(Domain, id)

  def delete(%Domain{} = record) do
    Repo.delete(record)
  end

  def create(attrs \\ %{}) do
    %Domain{}
    |> Domain.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Domain{} = record, attrs) do
    record
    |> Domain.changeset(attrs)
    |> Repo.update()
  end

  def changeset(%Domain{} = record, attrs \\ %{}) do
    Domain.changeset(record, attrs)
  end
end
