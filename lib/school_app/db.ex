defmodule SchoolApp.Db do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.Database
  alias SchoolApp.QueryUtils

  def teacher_list do
    QueryUtils.query(Database.Teacher, [:id, :name])
    |> Repo.all()
    |> Enum.sort(&(&1.name <= &2.name))
  end

  def grades_by_teacher(teacher_id) do
    SchoolApp.TeachersGrades.list(%{teacher_id: teacher_id})
    |> SchoolApp.TeachersGrades.load_grades()
    |> Enum.sort(&(&1.grade_id <= &2.grade_id))
    |> Enum.map(&%{name: &1.grade.name, id: &1.grade_id})
  end

  def classes_by_teacher(teacher_id) do
    SchoolApp.TeachersClasses.list(%{teacher_id: teacher_id})
    |> SchoolApp.TeachersClasses.load_classes()
    |> Enum.sort(&(&1.class_id <= &2.class_id))
    |> Enum.map(&%{code: &1.class.code, id: &1.class_id})
  end

  def student_list(teacher_id, class_id, grade_id) do
    from(s in SchoolApp.Database.Student,
      join: tg in TeacherGrade,
      on: s.grade_id == tg.grade_id,
      join: tc in TeacherClass,
      on: tg.teacher_id == tc.teacher_id,
      join: cg in ClassGrade,
      on: cg.class_id == tc.class_id and cg.grade_id == tg.grade_id,
      select: %{id: s.id, name: s.name, avatar: s.avatar}
    )
    |> filter_student_list_by_teacher(teacher_id)
    |> filter_student_list_by_class(class_id)
    |> filter_student_list_by_grade(grade_id)
    |> Repo.all()
  end

  defp filter_student_list_by_teacher(qy, 0), do: qy

  defp filter_student_list_by_teacher(qy, teacher_id),
    do: from([s, tg, tc, cg] in qy, where: tg.teacher_id == ^teacher_id)

  defp filter_student_list_by_class(qy, 0), do: qy

  defp filter_student_list_by_class(qy, class_id),
    do: from([s, tg, tc, cg] in qy, where: tc.class_id == ^class_id)

  defp filter_student_list_by_grade(qy, 0), do: qy

  defp filter_student_list_by_grade(qy, grade_id),
    do: from([s, tg, tc, cg] in qy, where: tg.grade_id == ^grade_id)

  def domains_by_student(student_id) do
    from(sd in SchoolApp.Database.StudentDomain,
      join: d in Domain,
      on: d.id == sd.domain_id,
      select: %{id: d.id, name: d.name},
      where: sd.student_id == ^student_id
    )
    |> Repo.all()
  end

  # select b.id, b.name, a.student_id
  # from students_goals a, goals b
  # where b.id = a.goal_id
  # and b.domain_id = 2
  # and a.student_id = 319

  def goals_by_student_domain(student_id, domain_id) do
    from(sg in SchoolApp.Database.StudentGoal,
      join: g in Goal,
      on: g.id == sg.goal_id,
      select: %{id: g.id, name: g.name},
      where:
        sg.student_id == ^student_id and
          g.domain_id == ^domain_id
    )
    |> Repo.all()
  end
end
