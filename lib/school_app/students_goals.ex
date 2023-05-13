defmodule SchoolApp.StudentsGoals do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database.StudentGoal
  use SchoolAppWeb, :verified_routes

  def app_item_config do
    %{
      id: :students_goals,
      link: ~p"/students_goals",
      icon: ["hero-user", "hero-check-circle"],
      name: "Students / Goals",
      item_title: "",
      form_rec_id: "student_goal",
      changeset_fn: &changeset(&1, &2),
      update_fn: &update_record(&1, &2),
      create_fn: &create(&1),
      delete_fn: &delete(&1),
      get_rec_fn: &get_record!(&1),
      schema: %StudentGoal{},
      index_list_base: &index_list_base/0,
      index_cols: [:domain_name, :goal_name],
      edit_kind: :uneditable,
      form_cols: [
        %{
          fieldname: :goal_id,
          label: "Goal",
          type: "select",
          options_fn: &SchoolApp.Goals.web_options_list/0
        }
      ]
    }
  end

  def list(filter) do
    query(filter)
    |> Repo.all()
  end

  def load_goals(list) do
    Repo.preload(list, [:goal])
  end

  def query(filter) do
    qy = from(a in StudentGoal)
    Enum.reduce(filter, qy, &filter_query(&1, &2))
  end

  defp filter_query({:student_id, student_id}, qy),
    do: from(q in qy, where: q.student_id == ^student_id)

  defp filter_query({:goal_id, goal_id}, qy),
    do: from(q in qy, where: q.goal_id == ^goal_id)

  def create_student_goal(attrs \\ %{}) do
    %StudentGoal{}
    |> StudentGoal.changeset(attrs)
    |> Repo.insert()
  end

  def changeset(%StudentGoal{} = record, attrs \\ %{}) do
    StudentGoal.changeset(record, attrs)
  end

  def update_record(%StudentGoal{} = record, attrs) do
    record
    |> StudentGoal.changeset(attrs)
    |> Repo.update()
  end

  def create(attrs \\ %{}) do
    %StudentGoal{}
    |> StudentGoal.changeset(attrs)
    |> Repo.insert()
  end

  def delete(%StudentGoal{} = record) do
    Repo.delete(record)
  end

  def get_record!(id), do: Repo.get!(StudentGoal, id)

  def index_list_base do
    from students_goals in "students_goals",
      join: goals in "goals",
      on: students_goals.goal_id == goals.id,
      join: domains in "domains",
      on: goals.domain_id == domains.id,
      select: %{
        id: students_goals.id,
        student_id: students_goals.student_id,
        goal_id: students_goals.goal_id,
        goal_name: goals.name,
        domain_name: domains.name
      },
      order_by: [domains.name, goals.name]
  end
end
