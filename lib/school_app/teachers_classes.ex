defmodule SchoolApp.TeachersClasses do
  import Ecto.Query, warn: false
  alias SchoolApp.Repo
  alias SchoolApp.QueryUtils
  alias SchoolApp.Database.TeacherClass
  use SchoolAppWeb, :verified_routes

  def list(filter) do
    QueryUtils.filter(TeacherClass, filter)
    |> Repo.all()
  end

  def app_item_config do
    %{
      id: :teachers_classes,
      link: ~p"/teachers_classes",
      icon: ["hero-user-group", "hero-building-library"],
      name: "Teachers / Classes",
      item_title: "",
      form_rec_id: "teacher_class",
      changeset_fn: &SchoolApp.TeachersClasses.changeset(&1, &2),
      update_fn: &SchoolApp.TeachersClasses.update(&1, &2),
      create_fn: &SchoolApp.TeachersClasses.create(&1),
      delete_fn: &SchoolApp.TeachersClasses.delete(&1),
      get_rec_fn: &SchoolApp.TeachersClasses.get_record!(&1),
      index_list_base: &SchoolApp.TeachersClasses.index_list_base/0,
      schema: %SchoolApp.Database.TeacherClass{},
      index_cols: [:class_code],
      edit_kind: :uneditable,
      form_cols: [
        %{
          fieldname: :class_id,
          label: "Class",
          type: "select",
          options_fn: &SchoolApp.Classes.web_options_list/0
        }
      ]
    }
  end

  def load_classes(list) do
    Repo.preload(list, [:class])
  end

  def create_teacher_class(attrs \\ %{}) do
    %TeacherClass{}
    |> TeacherClass.changeset(attrs)
    |> Repo.insert()
  end

  def changeset(%TeacherClass{} = record, attrs \\ %{}) do
    TeacherClass.changeset(record, attrs)
  end

  def update(%TeacherClass{} = record, attrs) do
    record
    |> TeacherClass.changeset(attrs)
    |> Repo.update()
  end

  def create(attrs \\ %{}) do
    %TeacherClass{}
    |> TeacherClass.changeset(attrs)
    |> Repo.insert()
  end

  def delete(%TeacherClass{} = record) do
    Repo.delete(record)
  end

  def get_record!(id), do: Repo.get!(TeacherClass, id)

  def index_list_base do
    from teachers_classes in "teachers_classes",
      join: classes in "classes",
      on: teachers_classes.class_id == classes.id,
      select: %{
        id: teachers_classes.id,
        teacher_id: teachers_classes.teacher_id,
        class_id: teachers_classes.class_id,
        class_code: classes.code
      }
  end
end
