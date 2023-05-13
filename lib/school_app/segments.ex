defmodule SchoolApp.Segments do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database.Segment
  alias SchoolApp.QueryUtils
  alias SchoolApp.DbWeb
  use SchoolAppWeb, :verified_routes

  def list do
    qy = QueryUtils.query(Segment, [:id, :name])
    Repo.all(qy)
  end

  def web_options_list do
    DbWeb.get_select_list_from("segments")
  end

  def app_item_config do
    %{
      id: :segments,
      link: ~p"/segments",
      icon: ["hero-cog"],
      name: "Segments",
      item_title: "Segment",
      form_rec_id: "segment",
      changeset_fn: &SchoolApp.Segments.changeset(&1, &2),
      update_fn: &SchoolApp.Segments.update(&1, &2),
      create_fn: &SchoolApp.Segments.create(&1),
      delete_fn: &SchoolApp.Segments.delete(&1),
      get_rec_fn: &SchoolApp.Segments.get_record!(&1),
      list_records: &SchoolApp.Segments.list/0,
      schema: %SchoolApp.Database.Segment{}
    }
  end

  def get(id) do
    qy = QueryUtils.query_by_id(Segment, id, [:id, :name])
    Repo.one(qy)
  end

  def list_records do
    Repo.all(Segment)
  end

  def get_record!(id), do: Repo.get!(Segment, id)

  def create(attrs \\ %{}) do
    %Segment{}
    |> Segment.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Segment{} = segment, attrs) do
    segment
    |> Segment.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Segment{} = segment) do
    Repo.delete(segment)
  end

  def changeset(%Segment{} = segment, attrs \\ %{}) do
    Segment.changeset(segment, attrs)
  end
end
