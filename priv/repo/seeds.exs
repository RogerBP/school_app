# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SchoolApp.Repo.insert!(%SchoolApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# import Ecto.Query
# alias SchoolApp.Repo

# alias SchoolApp.Database.Domains
# alias SchoolApp.Database.TeacherClass
# alias SchoolApp.Database.ClassGrade

# SchoolApp.Districts.create_district(%{"name" => "OCPS"})
# SchoolApp.Schools.create_school(%{"name" => "UCP of Central Florida", "district_id" => 1})
# SchoolApp.Courses.create_course(%{"name" => "Standard"})
# SchoolApp.Courses.create_course(%{"name" => "Access Points"})

# SchoolApp.Segments.create_segment(%{"name" => "preK"})
# SchoolApp.Segments.create_segment(%{"name" => "Elementary"})
# SchoolApp.Segments.create_segment(%{"name" => "Middle"})
# SchoolApp.Segments.create_segment(%{"name" => "High"})

# SchoolApp.CoursesSegments.create_course_segment(%{course_id: course_id, segment_id: segment_id})

# schools = SchoolApp.Schools.list()
# courses = SchoolApp.Courses.list()

# segs = SchoolApp.Segments.list()

# for course <- courses,
#     seg <- segs,
#     do:
#       SchoolApp.CoursesSegments.create_course_segment(%{
#         course_id: course.id,
#         segment_id: seg.id
#       })

# for course <- courses,
#     school <- schools,
#     do:
#       SchoolApp.SchoolsCourses.create_schools_course(%{
#         course_id: course.id,
#         school_id: school.id
#       })

# for job <- ~w(Teacher Therapist Administrator T.A.), do: SchoolApp.Jobs.create_job(%{name: job})
# for _ <- 1..30, do: SchoolApp.Teachers.create_teacher(%{name: Faker.Person.En.name()})

# jobs = SchoolApp.Jobs.list()

# for i <- 1..30,
#     do:
#       SchoolApp.TeachersJobsSchools.create_teacher_job_school(%{
#         school_id: 1,
#         teacher_id: i,
#         job_id: rem(i, 4) + 1
#       })

# for i <- 1..20,
#     do:
#       SchoolApp.Classes.create_class(%{
#         code: "CLASS_#{String.pad_leading(Integer.to_string(i), 3, "0")}"
#       })

# for name <- ~w(Pre-K Kindergarten First Second Third Fourth Fifth Sixth Seventh Eighth),
#     do: SchoolApp.Grades.create_grade(%{name: name})

# SchoolApp.Grades.create_grade(%{name: "High school"})

# grades = SchoolApp.Grades.list

# for class_id <- 1..20,
#     do:
#       for(
#         grade_id <- class_id..(class_id + 2),
#         do:
#           SchoolApp.ClassesGrades.create_class_grade(%{
#             class_id: class_id,
#             grade_id: rem(grade_id, 11) + 1
#           })
#       )

# for class_id <- 1..20,
#     do:
#       for(
#         teacher_id <- ((class_id - 1) * 3)..((class_id - 1) * 3 + 2),
#         do:
#           SchoolApp.TeachersClasses.create_teacher_class(%{
#             class_id: class_id,
#             teacher_id: rem(teacher_id, 30) + 1
#           })
#       )

# query =
#   from tc in TeacherClass,
#     join: cg in ClassGrade,
#     on: tc.class_id == cg.class_id,
#     distinct: true,
#     select: %{teacher_id: tc.teacher_id, grade_id: cg.grade_id}

# tgs = Repo.all(query)
# Enum.map(tgs, &SchoolApp.TeachersGrades.create_teacher_grade(&1))

# Enum.map(
#   ~w(Communication Independent-Functioning Social-Emotional Instructional Transition),
#   &SchoolApp.Domains.create_domain(%{name: &1})
# )

# for domain <- domains = SchoolApp.Domains.list(),
#     _ <- 1..5,
#     do: SchoolApp.Goals.create_goal(%{domain_id: domain.id, name: Faker.Lorem.sentence(5..5)})

# for i <- 1..300, do: SchoolApp.Students.create_student_fake(i)

### domains = SchoolApp.Domains.list() |> Enum.map(&%{domain_id: &1.id})

# goals = SchoolApp.Goals.list() |> Enum.map(&%{goal_id: &1.id})
# sts = SchoolApp.Students.list()

# for st <- sts,
#     _ <- 1..10,
#     do:
#       SchoolApp.StudentsGoals.create_student_goal(
#         Map.merge(Enum.random(goals), %{student_id: st.id})
#       )

# query =
#   from sg in SchoolApp.Database.StudentGoal,
#     join: g in SchoolApp.Database.Goal,
#     on: sg.goal_id == g.id,
#     distinct: true,
#     select: %{student_id: sg.student_id, domain_id: g.domain_id}

# stds = Repo.all(query)
# stds |> Enum.map(&SchoolApp.StudentsDomains.create_student_domain(&1))

# date_range = Date.range(~D[2022-01-01], ~D[2022-12-31])
# qy = from s in "students", select: %{student_id: s.id, grade_id: s.grade_id}
# sts = Repo.all(qy)
# for st <- sts, do: SchoolApp.Assessments.create_fake(st.student_id, st.grade_id, date_range)
