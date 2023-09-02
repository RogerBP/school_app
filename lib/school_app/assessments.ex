defmodule SchoolApp.Assessments do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database.Assessment

  # def load_refs(assessments) do
  #   Repo.preload(assessments, [:student, :teacher, :goal, :domain, :class, :grade])
  # end

  # def load_refs(assessments, refs) do
  #   Repo.preload(assessments, refs)
  # end

  def get_by_id!(id), do: Repo.get!(Assessment, id)

  def create_assessment(attrs \\ %{}) do
    %Assessment{}
    |> Assessment.changeset(attrs)
    |> Repo.insert()
  end

  def teachers_classes_from_grade(grade_id) do
    qy =
      from tc in "teachers_classes",
        join: tg in "teachers_grades",
        on: tc.teacher_id == tg.teacher_id,
        join: cg in "classes_grades",
        on: tc.class_id == cg.class_id and tg.grade_id == cg.grade_id,
        where: tg.grade_id == ^grade_id,
        select: %{teacher_id: tc.teacher_id, class_id: tc.class_id}

    Repo.all(qy)
  end

  def goals_from_student(student_id) do
    qy =
      from sg in "students_goals",
        where: sg.student_id == ^student_id,
        select: %{goal_id: sg.id, domain_id: sg.domain_id}
    Repo.all(qy)
  end

  # def create_fake(student_id, grade_id, date_range) do
  #   # student_id = 316
  #   # grade_id = 7
  #   # date_range = Date.range(~D[2022-01-01], ~D[2022-12-31])

  #   goals = goals_from_student(student_id)
  #   tc = teachers_classes_from_grade(grade_id)

  #   rates =
  #     for goal <- goals,
  #         date <- date_range,
  #         _ <- 1..5,
  #         do:
  #           Map.merge(
  #             %{
  #               student_id: student_id,
  #               goal_id: goal.goal_id,
  #               domain_id: goal.domain_id,
  #               grade_id: grade_id,
  #               value: Enum.random([-1, 0, 1]),
  #               inserted_at:
  #                 NaiveDateTime.new!(
  #                   date,
  #                   Time.new!(
  #                     Enum.random(8..18),
  #                     Enum.random(0..59),
  #                     Enum.random(0..59),
  #                     Enum.random(0..999_999)
  #                   )
  #                 )
  #             },
  #             Enum.random(tc)
  #           )

  #   for rate <- rates, do: create_assessment(rate)
  # end
end
