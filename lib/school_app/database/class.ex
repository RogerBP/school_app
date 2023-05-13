defmodule SchoolApp.Database.Class do
  use Ecto.Schema
  import Ecto.Changeset

  schema "classes" do
    field :code, :string

    timestamps()
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:code])
    |> validate_required([:code])
  end
end
