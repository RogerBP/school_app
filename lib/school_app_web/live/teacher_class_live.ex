defmodule SchoolAppWeb.TeacherClassLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.IndexComponent
  alias SchoolAppWeb.CustomComponents

  @app_item :teachers_classes

  def mount(_params, _session, socket) do
    parent_list = SchoolApp.Teachers.web_options_list()
    {parent_name, id} = hd(parent_list)
    link_tc = SchoolAppWeb.AppUtils.get_item(:teachers)
    link_cl = SchoolAppWeb.AppUtils.get_item(:classes)

    socket =
      assign(socket,
        parent_list: parent_list,
        parent_id: id,
        parent_descr: "Teacher: #{parent_name}",
        app_item: @app_item,
        link_cl: %{
          link: link_cl.link,
          icon: link_cl.icon,
          name: link_cl.name
        },
        link_tc: %{
          link: link_tc.link,
          icon: link_tc.icon,
          name: link_tc.name
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
        <.header>Teacher</.header>
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
      parent_field={:teacher_id}
      parent_id={@parent_id}
      parent_descr={@parent_descr}
    />

    <CustomComponents.link_button link={@link_tc.link} icon={@link_tc.icon}>
      <%= @link_tc.name %>
    </CustomComponents.link_button>

    <CustomComponents.link_button link={@link_cl.link} icon={@link_cl.icon}>
      <%= @link_cl.name %>
    </CustomComponents.link_button>

    <%!-- <pre><%= inspect assigns, pretty: true %></pre> --%>
    """
  end

  def handle_event("change_parent", %{"value" => id}, socket) do
    id = String.to_integer(id)
    rec = SchoolApp.Teachers.get(id)

    socket =
      assign(socket,
        parent_id: id,
        parent_descr: "Teacher: #{rec.name}"
      )

    {:noreply, socket}
  end
end
