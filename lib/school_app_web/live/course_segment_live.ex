defmodule SchoolAppWeb.CourseSegmentLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.IndexComponent
  alias SchoolAppWeb.CustomComponents

  @app_item :courses_segments

  def mount(_params, _session, socket) do
    parent_list = SchoolApp.DbWeb.get_select_list_from("courses")
    {parent_name, id} = hd(parent_list)
    link_co = SchoolAppWeb.AppUtils.get_item(:courses)
    link_sg = SchoolAppWeb.AppUtils.get_item(:segments)

    socket =
      assign(socket,
        parent_list: parent_list,
        parent_id: id,
        parent_descr: "Course: #{parent_name}",
        app_item: @app_item,
        link_co: %{
          link: link_co.link,
          icon: link_co.icon,
          name: link_co.name
        },
        link_sg: %{
          link: link_sg.link,
          icon: link_sg.icon,
          name: link_sg.name
        }
      )

    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(app_item: @app_item)
     |> assign(params: params)}
  end

  def render(assigns) do
    ~H"""
    <div class="border border-gray-400 bg-sky-100 rounded h-full w-full">
      <div class="border-b rounded p-2">
        <.header>Course</.header>
        <.input
          phx-click="change_parent"
          type="select"
          name="parent_id"
          value={@parent_id}
          options={@parent_list}
        />
      </div>
    </div>

    <.live_component
      module={IndexComponent}
      id={"#{@app_item}-index"}
      app_item={@app_item}
      live_action={@live_action}
      params={@params}
      parent_field={:course_id}
      parent_id={@parent_id}
      parent_descr={@parent_descr}
    />

    <CustomComponents.link_button link={@link_co.link} icon={@link_co.icon}>
      <%= @link_co.name %>
    </CustomComponents.link_button>
    <CustomComponents.link_button link={@link_sg.link} icon={@link_sg.icon}>
      <%= @link_sg.name %>
    </CustomComponents.link_button>

    <%!-- <pre><%= inspect assigns, pretty: true %></pre> --%>
    """
  end

  def handle_event("change_parent", %{"value" => id}, socket) do
    id = String.to_integer(id)
    rec = SchoolApp.Courses.get(id)

    socket =
      assign(socket,
        parent_id: id,
        parent_descr: "Course: #{rec.name}"
      )

    {:noreply, socket}
  end
end
