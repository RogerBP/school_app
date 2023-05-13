defmodule SchoolApp.WebUtils do
  # Ex.: select_list([%{id: 1, name: "Nome"}])
  def select_list(db_list) do
    db_list
    |> Enum.map(&{&1.name, &1.id})
  end
end
