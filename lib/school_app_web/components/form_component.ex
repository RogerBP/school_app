defmodule SchoolAppWeb.FormComponent do
  use SchoolAppWeb, :live_component
  alias SchoolAppWeb.AppUtils

  @impl true
  def update(%{record: record, app_item: app_item} = assigns, socket) do
    changeset = AppUtils.get_changeset(app_item, record, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-2">
      <div>
        <.header>
          <%= @title %>
        </.header>
        <.header>
          <%= @parent_descr %>
        </.header>

        <.simple_form
          for={@form}
          id={"#{@app_item}-form"}
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
        >
          <div :for={col <- AppUtils.get_form_cols(@app_item)}>
            <.input
              field={@form[col.fieldname]}
              label={col.label}
              type={get_col_type(col)}
              options={get_col_options(col)}
              value={get_col_value(@form[col.fieldname], @live_action, @parent_field, @parent_id)}
            />
          </div>
          <:actions>
            <.button phx-disable-with="Saving...">Save</.button>
          </:actions>
        </.simple_form>
      </div>

      <%!-- <pre><%= inspect assigns, pretty: true %></pre> --%>
    </div>
    """
  end

  defp get_col_type(col) do
    Map.get(col, :type) || "text"
  end

  defp get_col_options(col) do
    type = get_col_type(col)
    get_col_options(col, type)
  end

  defp get_col_options(col, "select") do
    col.options_fn.()
  end

  defp get_col_options(_, _), do: []

  defp get_col_value(field, _, nil, _), do: field.value
  defp get_col_value(field, :edit, _, _), do: field.value

  defp get_col_value(field, :new, parent_field, parent_id) do
    if field.field == parent_field do
      parent_id
    else
      field.value
    end
  end

  @impl true
  def handle_event("validate", params, socket) do
    app_item = socket.assigns.app_item
    form_rec_id = AppUtils.get_form_rec_id(app_item)
    %{^form_rec_id => rec_params} = params

    # IO.inspect("----------------- validate ----------------------")

    changeset =
      AppUtils.get_changeset(app_item, socket.assigns.record, rec_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
    # {:noreply, socket}
  end

  def handle_event("save", params, socket) do
    app_item = socket.assigns.app_item
    form_rec_id = AppUtils.get_form_rec_id(app_item)
    %{^form_rec_id => rec_params} = params

    rec_params =
      add_parent_data(rec_params, socket.assigns.parent_field, socket.assigns.parent_id)

    IO.inspect("---------------- save ----------------------")
    IO.inspect(rec_params)

    save(socket, socket.assigns.action, app_item, rec_params)
  end

  def add_parent_data(rec_params, nil, _), do: rec_params

  def add_parent_data(rec_params, parent_field, parent_id) do
    field_name = Atom.to_string(parent_field)
    Map.put(rec_params, field_name, parent_id)
  end

  defp save(socket, :edit, app_item, rec_params) do
    case AppUtils.update(app_item, socket.assigns.record, rec_params) do
      {:ok, _record} ->
        {:noreply,
         socket
         |> put_flash(:info, "Record updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign_form(changeset)}
    end
  end

  defp save(socket, :new, app_item, rec_params) do
    case AppUtils.create(app_item, rec_params) do
      {:ok, _record} ->
        {:noreply,
         socket
         |> put_flash(:info, "Record created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
