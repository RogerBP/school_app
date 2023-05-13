defmodule SchoolApp.QueryUtils do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo

  # filter = %{id: [1, 2, 3], name: "teste"}
  # fields = [:id, :name]
  # qy = QueryUtils.query("goals", fields, filter)

  # graph_params = %{
  #   date_start: ~N[2022-01-01 00:00:00],
  #   date_end: ~N[2022-02-01 00:00:00],
  #   goal_id: 20,
  #   student_id: 510
  # }

  def query_by_id(schema, id, fields \\ []), do: query(schema, fields, %{id: id})

  def query(schema, fields \\ [], filter \\ %{}) do
    table_name(schema)
    |> filter(filter)
    |> select_fields(fields)
  end

  def get_count(schema, filter \\ %{}) do
    table_name = table_name(schema)
    qy = from(p in table_name, select: count())
    qy = filter(qy, filter)
    hd(Repo.all(qy))
  end

  def sort(query, %{sort_by: sort_by, sort_order: sort_order}) do
    order_by(query, {^sort_order, ^sort_by})
  end

  def sort(query, _options), do: query

  def paginate(query, %{page: page, per_page: per_page}) do
    offset = max((page - 1) * per_page, 0)

    query
    |> limit(^per_page)
    |> offset(^offset)
  end

  def paginate(query, _options), do: query

  def table_name(schema) when is_binary(schema), do: schema
  def table_name(schema), do: schema.__struct__.__meta__.source

  def filter(schema, filter) do
    qy = from(a in schema)
    apply_filter(qy, filter)
  end

  def apply_filter(qy, filter) do
    Enum.reduce(filter, qy, &filter_query(&1, &2))
  end

  def select_fields(qy, %{}), do: qy
  def select_fields(qy, fields), do: from(q in qy, select: ^fields)

  defp filter_query({_, [_ | _]} = field_values, qy) do
    {f, values} = field_values
    from(q in qy, where: field(q, ^f) in ^values)
  end

  defp filter_query({f, %{start: v_ini, end: v_fim}}, qy) do
    from(q in qy, where: field(q, ^f) >= ^v_ini and field(q, ^f) < ^v_fim)
  end

  defp filter_query(field_value, qy),
    do: from(q in qy, where: ^[field_value])
end
