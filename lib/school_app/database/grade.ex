defmodule SchoolApp.Database.Grade do
  use Ecto.Schema
  import Ecto.Changeset

  schema "grades" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(grade, attrs) do
    grade
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
