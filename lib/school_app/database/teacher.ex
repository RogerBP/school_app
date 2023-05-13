defmodule SchoolApp.Database.Teacher do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teachers" do
    field :name, :string
    field :job_id, :id

    timestamps()
  end

  @doc false
  def changeset(teacher, attrs) do
    teacher
    |> cast(attrs, [:name, :job_id])
    |> validate_required([:name])
  end
end
