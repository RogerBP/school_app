defmodule SchoolApp.CoursesSegments do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.QueryUtils
  alias SchoolApp.Database.CourseSegment
  use SchoolAppWeb, :verified_routes

  def list do
    qy = QueryUtils.query(CourseSegment, [:course_id, :segment_id])
    Repo.all(qy)
  end

  def app_item_config do
    %{
      id: :courses_segments,
      link: ~p"/courses_segments",
      icon: ["hero-academic-cap", "hero-cog"],
      name: "Courses / Segments",
      item_title: "",
      form_rec_id: "course_segment",
      changeset_fn: &SchoolApp.CoursesSegments.changeset(&1, &2),
      update_fn: &SchoolApp.CoursesSegments.update(&1, &2),
      create_fn: &SchoolApp.CoursesSegments.create(&1),
      delete_fn: &SchoolApp.CoursesSegments.delete(&1),
      get_rec_fn: &SchoolApp.CoursesSegments.get_record!(&1),
      list_records: &SchoolApp.CoursesSegments.list/0,
      index_list_base: &SchoolApp.CoursesSegments.index_list_base/0,
      schema: %SchoolApp.Database.CourseSegment{},
      index_cols: [:segment_name],
      edit_kind: :uneditable,
      form_cols: [
        %{
          fieldname: :segment_id,
          label: "Segment",
          type: "select",
          options_fn: &SchoolApp.Segments.web_options_list/0
        }
      ]
    }
  end

  def index_list_base do
    from courses_segments in "courses_segments",
      join: segments in "segments",
      on: courses_segments.segment_id == segments.id,
      select: %{
        id: courses_segments.id,
        course_id: courses_segments.course_id,
        segment_id: courses_segments.segment_id,
        segment_name: segments.name
      }
  end

  def get(id) do
    qy = QueryUtils.query_by_id(CourseSegment, id, [:course_id, :segment_id])
    Repo.one(qy)
  end

  def list_records do
    Repo.all(CourseSegment)
  end

  def get_record!(id), do: Repo.get!(CourseSegment, id)

  def create(attrs \\ %{}) do
    %CourseSegment{}
    |> CourseSegment.changeset(attrs)
    |> Repo.insert()
  end

  def update(%CourseSegment{} = course_segment, attrs) do
    course_segment
    |> CourseSegment.changeset(attrs)
    |> Repo.update()
  end

  def delete(%CourseSegment{} = course_segment) do
    Repo.delete(course_segment)
  end

  def changeset(%CourseSegment{} = course_segment, attrs \\ %{}) do
    CourseSegment.changeset(course_segment, attrs)
  end

  def create_course_segment(attrs \\ %{}) do
    %CourseSegment{}
    |> CourseSegment.changeset(attrs)
    |> Repo.insert()
  end
end
