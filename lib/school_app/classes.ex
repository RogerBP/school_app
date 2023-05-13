defmodule SchoolApp.Classes do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database.Class
  alias SchoolApp.QueryUtils
  use SchoolAppWeb, :verified_routes

  def list do
    qy = QueryUtils.query(Class, [:id, :code])
    Repo.all(qy)
  end

  def web_options_list do
    list()
    |> Enum.map(&%{name: &1.code, id: &1.id})
    |> SchoolApp.WebUtils.select_list()
  end

  def app_item_config do
    %{
      id: :classes,
      link: ~p"/classes",
      icon: ["hero-building-library"],
      name: "Classes",
      item_title: "Class",
      form_rec_id: "class",
      changeset_fn: &SchoolApp.Classes.changeset(&1, &2),
      update_fn: &SchoolApp.Classes.update(&1, &2),
      create_fn: &SchoolApp.Classes.create(&1),
      delete_fn: &SchoolApp.Classes.delete(&1),
      get_rec_fn: &SchoolApp.Classes.get_record!(&1),
      list_records: &SchoolApp.Classes.list/0,
      schema: %SchoolApp.Database.Class{},
      index_cols: [:code],
      form_cols: [%{fieldname: :code, label: "Code"}],
      list_fields: [:id, :code],
      sort_field: :code
    }
  end

  def get(id) do
    qy = QueryUtils.query_by_id(Class, id, [:id, :name])
    Repo.one(qy)
  end

  def list_records do
    Repo.all(Class)
  end

  def get_record!(id), do: Repo.get!(Class, id)

  def delete(%Class{} = record) do
    Repo.delete(record)
  end

  def create(attrs \\ %{}) do
    %Class{}
    |> Class.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Class{} = record, attrs) do
    record
    |> Class.changeset(attrs)
    |> Repo.update()
  end

  def changeset(%Class{} = record, attrs \\ %{}) do
    Class.changeset(record, attrs)
  end
end
