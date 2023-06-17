defmodule SchoolApp.Graph do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Utils
  alias SchoolApp.QueryUtils
  alias SchoolApp.Database.Assessment
  alias SchoolApp.Database.Goal
  alias Timex

  # graph_params = %{date_start: "01/01/2022", date_end: "01/31/2022", goal_id: 20, student_id: 510}
  # data = SchoolApp.GraphUtils.get_data_graph(graph_params)
  # goals = SchoolApp.GraphUtils.get_goals_from_graph_data(data)
  # datasets = SchoolApp.GraphUtils.get_dataset_from_graph_data(data, goals)
  # labels = SchoolApp.GraphUtils.load_labels_from_datasets(datasets)

  def get_data_graph(graph_params) do
    {:ok, date_start} = Timex.parse(graph_params.date_start, "{YYYY}-{M}-{D}")
    {:ok, date_end} = Timex.parse(graph_params.date_end, "{YYYY}-{M}-{D}")
    date_end = NaiveDateTime.add(date_end, 1, :day)

    qy =
      QueryUtils.filter(Assessment, %{
        student_id: graph_params.student_id,
        goal_id: graph_params.goal_id,
        inserted_at: %{start: date_start, end: date_end}
      })

    qy =
      from a in qy,
        group_by: [a.goal_id, fragment("date_part('day', ?)", a.inserted_at)],
        select: %{
          goal_id: a.goal_id,
          day: fragment("date_part('day', ?)", a.inserted_at),
          total: sum(a.value)
        }

    Repo.all(qy)
  end

  def get_goals_from_graph_data(data) do
    goals = Enum.map(data, &%{goal_id: &1.goal_id}) |> Enum.uniq()
    ids = Enum.map(goals, & &1.goal_id)

    SchoolApp.QueryUtils.query(Goal, [:id, :name], %{id: ids})
    |> Repo.all()
  end

  def get_dataset_from_graph_data(data, goals) do
    for goal <- goals do
      goal_data =
        Enum.filter(data, &(&1.goal_id == goal.id)) |> Enum.map(&Map.delete(&1, :goal_id))

      %{label: "Goal: #{goal.name}", dataset: goal_data}
    end
  end

  def load_labels_from_datasets(datasets) do
    Enum.reduce(datasets, [], fn ds, acc ->
      (acc ++ Enum.map(ds.dataset, &%{day: &1.day}))
      |> Enum.uniq()
    end)
    |> Enum.sort(&(&1 <= &2))
  end

  def normalize_datasets(datasets, labels) do
    for ds <- datasets do
      data =
        for lb <- labels do
          Utils.nvl(Enum.find(ds.dataset, &(&1.day == lb.day)), Map.merge(lb, %{total: 0}))
        end
        |> Enum.sort(&(&1.day <= &2.day))
        |> Enum.map(& &1.total)

      %{label: ds.label, data: data}
    end
  end

  def load_dataset(graph_params) do
    IO.inspect("==============> load_dataset <================ ")
    data = get_data_graph(graph_params)
    goals = get_goals_from_graph_data(data)
    datasets = get_dataset_from_graph_data(data, goals)

    labels = load_labels_from_datasets(datasets)
    datasets = normalize_datasets(datasets, labels)
    labels = Enum.map(labels, & &1.day)

    st =
      SchoolApp.QueryUtils.query(SchoolApp.Database.Student, [:name], %{
        id: graph_params.student_id
      })
      |> Repo.all()
      |> List.first()

    %{
      title: "Student: #{st.name}",
      labels: labels,
      datasets: datasets
    }
  end
end
