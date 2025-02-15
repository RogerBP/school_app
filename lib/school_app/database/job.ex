defmodule SchoolApp.Database.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jobs" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
