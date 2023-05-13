defmodule SchoolApp.Database.CourseSegment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses_segments" do
    field :course_id, :id
    field :segment_id, :id

    timestamps()
  end

  @doc false
  def changeset(course_segment, attrs) do
    course_segment
    |> cast(attrs, [:course_id, :segment_id])
    |> validate_required([:course_id, :segment_id])
  end
end
