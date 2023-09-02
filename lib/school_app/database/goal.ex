# defmodule SchoolApp.Database.Goal do
#   use Ecto.Schema
#   import Ecto.Changeset

#   schema "goals" do
#     field :name, :string
#     field :domain_id, :id

#     timestamps()
#   end

#   @doc false
#   def changeset(goal, attrs) do
#     goal
#     |> cast(attrs, [:name, :domain_id])
#     |> validate_required([:name, :domain_id])
#   end
# end
