# defmodule SchoolApp.Goals do
#   import Ecto.Query, warn: false
#   alias SchoolApp.Repo
#   alias SchoolApp.Database.Goal
#   alias SchoolApp.QueryUtils
#   use SchoolAppWeb, :verified_routes

#   def app_item_config do
#     %{
#       id: :goals,
#       link: ~p"/goals",
#       icon: ["hero-check-circle"],
#       name: "Goals",
#       item_title: "",
#       form_rec_id: "goal",
#       changeset_fn: &SchoolApp.Goals.changeset(&1, &2),
#       update_fn: &SchoolApp.Goals.update(&1, &2),
#       create_fn: &SchoolApp.Goals.create(&1),
#       delete_fn: &SchoolApp.Goals.delete(&1),
#       get_rec_fn: &SchoolApp.Goals.get_record!(&1),
#       list_records: &SchoolApp.Goals.list/0,
#       schema: %SchoolApp.Database.Goal{},
#       form_cols: [
#         %{
#           fieldname: :name,
#           label: "Goal"
#         }
#       ]
#     }
#   end

#   def list do
#     qy = QueryUtils.query(Goal, [:id, :name])
#     Repo.all(qy)
#   end

#   def get(id) do
#     qy = QueryUtils.query_by_id(Goal, id, [:id, :name])
#     Repo.one(qy)
#   end

#   def web_options_list do
#     qy =
#       from goals in "goals",
#         join: domains in "domains",
#         on: goals.domain_id == domains.id,
#         select: %{
#           id: goals.id,
#           goal_name: goals.name,
#           domain_name: domains.name
#         },
#         order_by: [domains.name, goals.name]

#     Repo.all(qy)
#     |> Enum.map(&%{name: "#{&1.domain_name} / #{&1.goal_name}", id: &1.id})
#     |> SchoolApp.WebUtils.select_list()
#   end

#   def list_records do
#     Repo.all(Goal)
#   end

#   def get_record!(id), do: Repo.get!(Goal, id)

#   def delete(%Goal{} = record) do
#     Repo.delete(record)
#   end

#   def create(attrs \\ %{}) do
#     %Goal{}
#     |> Goal.changeset(attrs)
#     |> Repo.insert()
#   end

#   def update(%Goal{} = record, attrs) do
#     record
#     |> Goal.changeset(attrs)
#     |> Repo.update()
#   end

#   def changeset(%Goal{} = record, attrs \\ %{}) do
#     Goal.changeset(record, attrs)
#   end
# end
