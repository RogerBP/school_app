defmodule SchoolApp.Repo.Migrations.CreateDistrict do
  use Ecto.Migration

  def change do
    # District (name)
    create table(:districts) do
      add :name, :string

      timestamps()
    end

    # School (name, district)
    create table(:schools) do
      add :name, :string
      add :district_id, references(:districts, on_delete: :nothing)

      timestamps()
    end

    create index(:schools, [:district_id])

    # Course (name)
    create table(:courses) do
      add :name, :string

      timestamps()
    end

    # Segment (name)
    create table(:segments) do
      add :name, :string

      timestamps()
    end

    # Course_Segment (course, segment)
    create table(:courses_segments) do
      add :course_id, references(:courses, on_delete: :nothing)
      add :segment_id, references(:segments, on_delete: :nothing)

      timestamps()
    end

    create index(:courses_segments, [:course_id])
    create index(:courses_segments, [:segment_id])

    create unique_index(
             :courses_segments,
             [:course_id, :segment_id],
             name: :courses_segments_ids_index
           )

    # Job (name)
    create table(:jobs) do
      add :name, :string

      timestamps()
    end

    # Teacher (name)
    create table(:teachers) do
      add :name, :string

      timestamps()
    end

    # Class (code)
    create table(:classes) do
      add :code, :string

      timestamps()
    end

    # Grade (name)
    create table(:grades) do
      add :name, :string

      timestamps()
    end

    # Class_Grade (class, grade)
    create table(:classes_grades) do
      add :class_id, references(:classes, on_delete: :nothing)
      add :grade_id, references(:grades, on_delete: :nothing)

      timestamps()
    end

    create index(:classes_grades, [:class_id])
    create index(:classes_grades, [:grade_id])

    create unique_index(:classes_grades, [:class_id, :grade_id],
             name: :classes_grades_class_id_grade_id_index
           )

    create unique_index(:classes_grades, [:grade_id, :class_id],
             name: :classes_grades_grade_id_class_id_index
           )

    # teachers_classes (class, teacher)
    create table(:teachers_classes) do
      add :teacher_id, references(:teachers, on_delete: :nothing)
      add :class_id, references(:classes, on_delete: :nothing)

      timestamps()
    end

    create index(:teachers_classes, [:teacher_id])
    create index(:teachers_classes, [:class_id])

    create unique_index(:teachers_classes, [:teacher_id, :class_id],
             name: :teachers_classes_teacher_id_class_id_index
           )

    create unique_index(:teachers_classes, [:class_id, :teacher_id],
             name: :teachers_classes_class_id_teacher_id_index
           )

    # teachers_grades
    create table(:teachers_grades) do
      add :teacher_id, references(:teachers, on_delete: :nothing)
      add :grade_id, references(:grades, on_delete: :nothing)

      timestamps()
    end

    create index(:teachers_grades, [:teacher_id])
    create index(:teachers_grades, [:grade_id])

    create unique_index(:teachers_grades, [:teacher_id, :grade_id],
             name: :teachers_classes_teacher_id_grade_id_index
           )

    create unique_index(:teachers_grades, [:grade_id, :teacher_id],
             name: :teachers_classes_grade_id_teacher_id_index
           )

    # Domain (name)
    create table(:domains) do
      add :name, :string

      timestamps()
    end

    # Goal (name)
    create table(:goals) do
      add :name, :string
      add :domain_id, references(:domains, on_delete: :nothing)

      timestamps()
    end

    create index(:goals, [:domain_id])

    # Student (name, avatar, code, class, grade)
    create table(:students) do
      add :code, :string
      add :name, :string
      add :avatar, :string
      add :grade_id, references(:grades, on_delete: :nothing)

      timestamps()
    end

    create index(:students, [:grade_id])

    # Tabela desnecessária por enquanto devido ao relacionamento Classes / Grades
    # students_classes
    # create table(:students_classes) do
    #   add :student_id, references(:students, on_delete: :nothing)
    #   add :class_id, references(:classes, on_delete: :nothing)

    #   timestamps()
    # end

    # create index(:students_classes, [:student_id])
    # create index(:students_classes, [:class_id])

    # create unique_index(:students_classes, [:student_id, :class_id],
    #          name: :students_classes_student_id_class_id_index
    #        )

    # create unique_index(:students_classes, [:class_id, :student_id],
    #          name: :students_classes_class_id_student_id_index
    #        )

    # Student_Domain(student, domain)
    create table(:students_domains) do
      add :student_id, references(:students, on_delete: :nothing)
      add :domain_id, references(:domains, on_delete: :nothing)

      timestamps()
    end

    create index(:students_domains, [:student_id])
    create index(:students_domains, [:domain_id])

    create unique_index(:students_domains, [:student_id, :domain_id],
             name: :students_domains_student_id_domain_id_index
           )

    create unique_index(:students_domains, [:domain_id, :student_id],
             name: :students_domains_domain_id_student_id_index
           )

    # students_goals
    create table(:students_goals) do
      add :student_id, references(:students, on_delete: :nothing)
      add :goal_id, references(:goals, on_delete: :nothing)

      timestamps()
    end

    create index(:students_goals, [:student_id])
    create index(:students_goals, [:goal_id])

    create unique_index(:students_goals, [:student_id, :goal_id],
             name: :students_goals_student_id_goal_id_index
           )

    create unique_index(:students_goals, [:goal_id, :student_id],
             name: :students_goals_goal_id_student_id_index
           )

    # Assessment
    create table(:assessments) do
      add :student_id, references(:students, on_delete: :nothing)
      add :teacher_id, references(:teachers, on_delete: :nothing)
      add :goal_id, references(:goals, on_delete: :nothing)
      add :domain_id, references(:domains, on_delete: :nothing)
      add :class_id, references(:classes, on_delete: :nothing)
      add :grade_id, references(:grades, on_delete: :nothing)
      add :value, :integer

      timestamps()
    end

    create index(:assessments, [:student_id])
    create index(:assessments, [:teacher_id])
    create index(:assessments, [:goal_id])
    create index(:assessments, [:domain_id])
    create index(:assessments, [:class_id])
    create index(:assessments, [:grade_id])
    create index(:assessments, [:inserted_at])
  end
end
