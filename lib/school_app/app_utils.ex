defmodule SchoolAppWeb.AppUtils do
  use SchoolAppWeb, :verified_routes

  def main_menu_itens do
    [
      SchoolApp.Courses.app_item_config(),
      SchoolApp.Segments.app_item_config(),
      SchoolApp.CoursesSegments.app_item_config(),
      SchoolApp.Jobs.app_item_config(),
      SchoolApp.Teachers.app_item_config(),
      SchoolApp.Classes.app_item_config(),
      SchoolApp.Grades.app_item_config(),
      SchoolApp.TeachersClasses.app_item_config(),
      SchoolApp.TeachersGrades.app_item_config(),
      SchoolApp.Domains.app_item_config(),
      SchoolApp.Goals.app_item_config(),
      SchoolApp.Students.app_item_config(),
      # SchoolApp.StudentsDomains.app_item_config(),
      SchoolApp.StudentsGoals.app_item_config(),
      %{
        id: :assessments,
        link: ~p"/rate",
        icon: ["hero-adjustments-vertical"],
        name: "Assessments"
      },
      %{
        link: ~p"/",
        icon: ["hero-chart-bar"],
        name: "Charts",
        id: :charts
      }
    ]
  end

  def get_item(id), do: hd(Enum.filter(main_menu_itens(), &(&1.id == id)))

  def get_item_name(id) do
    it = get_item(id)
    it.name
  end

  def get_item_title(id) do
    it = get_item(id)
    it.item_title
  end

  def get_icon(id) do
    it = get_item(id)
    it.icon
  end

  def get_form_component(id) do
    it = get_item(id)
    Map.get(it, :form_component) || SchoolAppWeb.FormComponent
  end

  def get_parent_field(id) do
    it = get_item(id)
    Map.get(it, :parent_field)
  end

  def get_form_cols(id) do
    it = get_item(id)
    cols = Map.get(it, :form_cols)
    cols || [%{fieldname: :name, label: "Name"}]
  end

  def get_index_cols(id) do
    it = get_item(id)
    cols = Map.get(it, :index_cols)
    cols || [:name]
  end

  def get_list_fields(id) do
    it = get_item(id)
    fields = Map.get(it, :list_fields)
    fields || [:id, :name]
  end

  def get_sort_field(id) do
    it = get_item(id)
    fields = Map.get(it, :sort_field)
    fields || :name
  end

  def get_link(id) do
    it = get_item(id)
    it.link
  end

  def get_changeset(id, record, params) do
    it = get_item(id)
    it.changeset_fn.(record, params)
  end

  def update(id, record, params) do
    it = get_item(id)
    it.update_fn.(record, params)
  end

  def create(id, params) do
    it = get_item(id)
    it.create_fn.(params)
  end

  def delete(id, rec_id) do
    it = get_item(id)
    record = it.get_rec_fn.(rec_id)
    it.delete_fn.(record)
  end

  def get_record(id, rec_id) do
    it = get_item(id)
    it.get_rec_fn.(rec_id)
  end

  def get_form_rec_id(id) do
    it = get_item(id)
    it.form_rec_id
  end

  def list_records(id) do
    it = get_item(id)
    it.list_records.()
  end

  def get_schema(id) do
    it = get_item(id)
    it.schema
  end

  def get_table(id) do
    it = get_item(id)
    Map.get(it, :table) || Atom.to_string(id)
  end

  def get_index_list_base(id) do
    it = get_item(id)
    Map.get(it, :index_list_base)
  end

  def get_form_edit_kind(id) do
    it = get_item(id)
    Map.get(it, :edit_kind) || :editable
  end
end
