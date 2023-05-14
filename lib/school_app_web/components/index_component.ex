defmodule SchoolAppWeb.IndexComponent do
  use SchoolAppWeb, :live_component
  alias SchoolAppWeb.AppUtils
  alias SchoolApp.QueryUtils
  alias SchoolApp.Repo

  def mount(socket) do
    IO.inspect("========================== mount index  ========================")

    socket =
      assign(socket,
        count: 0,
        records: [],
        page: 1,
        per_page: 5,
        max_page: 1,
        parent_id: 0,
        parent_app: nil,
        parent_field: nil,
        parent_descr: nil,
        filter: %{},
        display_field_fn: nil
      )

    {:ok, socket, temporary_assigns: [records: []]}
  end

  def update(assigns, socket) do
    IO.inspect("========================== update index  ========================")

    app_item = assigns.app_item

    socket =
      socket
      |> assign(assigns)
      |> assign(page: 1)
      |> assign_records()
      |> assign(base_link: SchoolAppWeb.AppUtils.get_link(app_item))
      |> assign(cols: SchoolAppWeb.AppUtils.get_index_cols(app_item))
      |> assign(edit_kind: SchoolAppWeb.AppUtils.get_form_edit_kind(app_item))
      |> apply_action(assigns.live_action, assigns.params)

    {:ok, socket}
  end

  slot(:buttons)

  def render(assigns) do
    ~H"""
    <div>
      <.modal
        :if={@live_action in [:new, :edit]}
        id={"#{@app_item}-#{@id}-modal"}
        show
        on_cancel={JS.patch(@base_link)}
      >
        <.live_component
          module={AppUtils.get_form_component(@app_item)}
          id={@record.id || :new}
          title={@page_title}
          action={@live_action}
          record={@record}
          patch={@base_link}
          app_item={@app_item}
          parent_field={@parent_field}
          parent_id={@parent_id}
          parent_descr={@parent_descr}
          live_action={@live_action}
        />
      </.modal>
    
      <div class="border border-gray-400 bg-sky-100 rounded h-full w-full">
        <div class="border-b rounded p-2">
          <.header>
            <div class="flex">
              <div :for={icon <- AppUtils.get_icon(@app_item)} class="p-2">
                <.icon name={icon} class="h-5 w-5" />
              </div>
    
              <div class="h-5 p-2">
                <%= AppUtils.get_item_name(@app_item) %>
              </div>
            </div>
    
            <:actions>
              <div class="flex gap-1">
                <.link patch={"#{@base_link}/new"}>
                  <.button>
                    <.icon name="hero-plus-solid" class="h-5 w-5" />
                  </.button>
                </.link>
    
                <div :if={@count > 5}>
                  <.button phx-target={@myself} phx-click="first-page">
                    <.icon name="hero-chevron-double-left" class="h-5 w-5" />
                  </.button>
    
                  <.button phx-target={@myself} phx-click="prior-page">
                    <.icon name="hero-chevron-left" class="h-5 w-5" />
                  </.button>
    
                  <.button phx-target={@myself} phx-click="next-page">
                    <.icon name="hero-chevron-right" class="h-5 w-5" />
                  </.button>
    
                  <.button phx-target={@myself} phx-click="last-page">
                    <.icon name="hero-chevron-double-right" class="h-5 w-5" />
                  </.button>
                </div>
              </div>
            </:actions>
          </.header>
        </div>
      </div>
    
      <div class="border border-gray-400 bg-white rounded h-full w-full" id={"#{@app_item}-Records"}>
        <div :for={register <- @records} id={"#{@app_item}-#{register.id}"}>
          <div class="border-b rounded flex">
            <%= for col <- @cols do %>
              <%= show_field(@display_field_fn, register, col) %>
            <% end %>
    
            <div class="justify-items-end w-36 items-center flex p-1">
              <div class="justify-items-end w-full">
                <%= render_slot(@buttons) %>
              </div>
    
              <div class="">
                <.link :if={@edit_kind == :editable} patch={"#{@base_link}/#{register.id}/edit"}>
                  <.button>
                    <.icon name="hero-pencil-square" class="h-5 w-5" />
                  </.button>
                </.link>
              </div>
    
              <div class="">
                <.link
                  phx-target={@myself}
                  phx-click={JS.push("delete", value: %{id: register.id})}
                  data-confirm="Are you sure?"
                >
                  <.button>
                    <.icon name="hero-trash" class="h-5 w-5" />
                  </.button>
                </.link>
              </div>
            </div>
          </div>
        </div>
      </div>
       <%!-- <pre><%= inspect [@page, @max_page, @count], pretty: true %></pre> --%>
    </div>
    """
  end

  def handle_event("first-page", _, socket) do
    socket =
      socket
      |> assign(page: 1)
      |> assign_records()

    {:noreply, socket}
  end

  def handle_event("prior-page", _, socket) do
    socket =
      socket
      |> update(:page, &max(&1 - 1, 1))
      |> assign_records()

    {:noreply, socket}
  end

  def handle_event("next-page", _, socket) do
    max_page = socket.assigns.max_page

    socket =
      socket
      |> update(:page, &min(&1 + 1, max_page))
      |> assign_records()

    {:noreply, socket}
  end

  def handle_event("last-page", _, socket) do
    socket =
      socket
      |> assign(page: socket.assigns.max_page)
      |> assign_records()

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    app_item = socket.assigns.app_item
    {:ok, _record} = AppUtils.delete(app_item, id)

    socket =
      socket
      |> assign_records()
      |> put_flash(:info, "Record deleted successfully")

    {:noreply, socket}
  end

  def apply_action(socket, :index, _params) do
    app_item = socket.assigns.app_item
    name = AppUtils.get_item_name(app_item)

    socket
    |> assign(:page_title, name)
    |> assign(:record, nil)
  end

  def apply_action(socket, :new, _params) do
    app_item = socket.assigns.app_item
    schema = AppUtils.get_schema(app_item)
    title = AppUtils.get_item_title(app_item)

    socket
    |> assign(:page_title, title)
    |> assign(:record, schema)
  end

  def apply_action(socket, :edit, %{"id" => id}) do
    app_item = socket.assigns.app_item
    rec = AppUtils.get_record(app_item, id)
    title = AppUtils.get_item_title(app_item)

    socket
    |> assign(:page_title, title)
    |> assign(:record, rec)
  end

  def get_filter_parent(_socket, filter, nil), do: filter

  def get_filter_parent(socket, filter, parent_field) do
    filter_parent(
      filter,
      parent_field,
      socket.assigns.parent_id
    )
  end

  def filter_parent(filter, parent_field, :new), do: filter_parent(filter, parent_field, 0)
  def filter_parent(filter, parent_field, parent_id), do: Map.put(filter, parent_field, parent_id)

  def assign_records(socket) do
    # IO.inspect("========================== assign_records ========================")
    app_item = socket.assigns.app_item
    table = AppUtils.get_table(app_item)
    filter = socket.assigns.filter
    filter = get_filter_parent(socket, filter, socket.assigns.parent_field)
    count = SchoolApp.QueryUtils.get_count(table, filter)
    page = socket.assigns.page
    per_page = socket.assigns.per_page
    max_page = trunc(Float.ceil(count / per_page))
    records = get_records(socket, app_item, page, per_page)
    records = get_empty_records(records)
    # IO.inspect(records)

    socket
    |> assign(max_page: max_page)
    |> assign(records: records)
    |> assign(count: count)
  end

  defp get_empty_records([]) do
    [%{id: 0, name: ""}]
  end

  defp get_empty_records(records), do: records

  def get_records(socket, app_item, page, per_page) do
    qybase_function = AppUtils.get_index_list_base(app_item)
    qybase = filter_query_base(socket, app_item, qybase_function)

    qybase
    |> QueryUtils.paginate(%{page: page, per_page: per_page})
    |> Repo.all()
  end

  def filter_query_base(socket, app_item, nil) do
    table = AppUtils.get_table(app_item)
    fields = AppUtils.get_list_fields(app_item)
    filter = socket.assigns.filter
    filter = get_filter_parent(socket, filter, socket.assigns.parent_field)
    sort_field = AppUtils.get_sort_field(app_item)

    QueryUtils.query(table, fields, filter)
    |> QueryUtils.sort(%{sort_by: sort_field, sort_order: :asc})
  end

  def filter_query_base(socket, _app_item, qybase_function) do
    qybase = qybase_function.()
    filter = socket.assigns.filter
    filter = get_filter_parent(socket, filter, socket.assigns.parent_field)
    QueryUtils.apply_filter(qybase, filter)
  end

  defp show_field(display_field_fn, register, col) do
    dado = Map.get(register, col)
    get_display_field(display_field_fn, register, col, dado)
  end

  defp get_display_field(nil, _, _, dado) do
    assigns = %{dado: dado}

    ~H"""
    <div class="p-2 font-bold border w-full items-center flex">
      <div>
        <%= @dado %>
      </div>
    </div>
    """
  end

  defp get_display_field(display_field_fn, register, col, dado) do
    display_field_fn.(register, col, dado)
  end
end

# qy = from courses_segments in "courses_segments"
# , join: segments in "segments"
# , on: courses_segments.segment_id == segments.id
# , select: [courses_segments.id, courses_segments.course_id, courses_segments.segment_id, segments.name]
# qa = from s in qy, where: s.id == 3
