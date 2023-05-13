defmodule SchoolApp.Districts do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database.District

  def list do
    Repo.all(District)
  end

  def load_schools(districts) do
    Repo.preload(districts, :schools)
  end

  def list_with_schools do
    list()
    |> load_schools()
  end

  def create_district(attrs \\ %{}) do
    %District{}
    |> District.changeset(attrs)
    |> Repo.insert()
  end
end
