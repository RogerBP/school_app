defmodule SchoolApp.Rate do
  alias SchoolApp.QueryUtils
  alias SchoolApp.Database.Teacher
  alias SchoolApp.Repo

  def get_teacher() do
    id = Enum.random(1..30)
    qy = QueryUtils.query_by_id(Teacher, id, [:id, :name])
    Repo.one(qy)
  end
end
