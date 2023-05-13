defmodule SchoolAppWeb.StudentGoalLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.IndexComponent
  alias SchoolAppWeb.CustomComponents

  @app_item :students_goals

  def mount(_params, _session, socket) do
    parent_list = SchoolApp.Students.web_options_list()
    {parent_name, id} = hd(parent_list)
    link_st = SchoolAppWeb.AppUtils.get_item(:students)
    link_goals = SchoolAppWeb.AppUtils.get_item(:goals)

    socket =
      assign(socket,
        parent_list: parent_list,
        parent_id: id,
        parent_descr: "Student: #{parent_name}",
        app_item: @app_item,
        link_st: %{
          link: link_st.link,
          icon: link_st.icon,
          name: link_st.name
        },
        link_goals: %{
          link: link_goals.link,
          icon: link_goals.icon,
          name: link_goals.name
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
        <.header>Student</.header>
        
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
      parent_field={:student_id}
      parent_id={@parent_id}
      parent_descr={@parent_descr}
    />
    <CustomComponents.link_button link={@link_st.link} icon={@link_st.icon}>
      <%= @link_st.name %>
    </CustomComponents.link_button>

    <CustomComponents.link_button link={@link_goals.link} icon={@link_goals.icon}>
      <%= @link_goals.name %>
    </CustomComponents.link_button>
     <%!-- <pre><%= inspect assigns, pretty: true %></pre> --%>
    """
  end

  def handle_event("change_parent", %{"value" => id}, socket) do
    id = String.to_integer(id)
    rec = SchoolApp.Students.get(id)

    socket =
      assign(socket,
        parent_id: id,
        parent_descr: "Student: #{rec.name}"
      )

    {:noreply, socket}
  end
end
