defmodule SchoolAppWeb.GoalLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.IndexComponent
  alias SchoolAppWeb.CustomComponents

  @app_item :goals

  def mount(_params, _session, socket) do
    parent_list = SchoolApp.DbWeb.get_select_list_from("domains")
    {parent_name, id} = hd(parent_list)

    link_cs = SchoolAppWeb.AppUtils.get_item(:domains)
    link_sg = SchoolAppWeb.AppUtils.get_item(:students_goals)

    socket =
      assign(socket,
        parent_list: parent_list,
        parent_id: id,
        parent_descr: "Domain: #{parent_name}",
        app_item: @app_item,
        link_cs: %{
          link: link_cs.link,
          icon: link_cs.icon,
          name: link_cs.name
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
        <.header>Domain</.header>
        <.input
          phx-click="change_domain"
          type="select"
          name="domain_id"
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
      parent_field={:domain_id}
      parent_id={@parent_id}
      parent_descr={@parent_descr}
    />

    <CustomComponents.link_button link={@link_cs.link} icon={@link_cs.icon}>
      <%= @link_cs.name %>
    </CustomComponents.link_button>

    <CustomComponents.link_button link={@link_sg.link} icon={@link_sg.icon}>
      <%= @link_sg.name %>
    </CustomComponents.link_button>

    <%!-- <pre><%= inspect assigns, pretty: true %></pre> --%>
    """
  end

  def handle_event("change_domain", %{"value" => id}, socket) do
    id = String.to_integer(id)
    rec = SchoolApp.Domains.get(id)

    socket =
      assign(socket,
        parent_id: id,
        parent_descr: "Domain: #{rec.name}"
      )

    {:noreply, socket}
  end
end
