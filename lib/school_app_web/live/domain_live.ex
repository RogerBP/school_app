defmodule SchoolAppWeb.DomainLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.IndexComponent
  alias SchoolAppWeb.CustomComponents

  @app_item :domains

  def mount(_params, _session, socket) do
    # link_cs = SchoolAppWeb.AppUtils.get_item(:goals)
    link_sg = SchoolAppWeb.AppUtils.get_item(:students_goals)

    {:ok,
     socket
     |> assign(
      #  link_cs: %{
      #    link: link_cs.link,
      #    icon: link_cs.icon,
      #    name: link_cs.name
      #  },
       link_sg: %{
         link: link_sg.link,
         icon: link_sg.icon,
         name: link_sg.name
       }
     )}
  end

  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(app_item: @app_item)
     |> assign(params: params)}
  end

  def render(assigns) do
    ~H"""
    <.live_component
      module={IndexComponent}
      id={"#{@app_item}-index"}
      app_item={@app_item}
      live_action={@live_action}
      params={@params}
    >
    </.live_component>

    <%!-- <CustomComponents.link_button link={@link_cs.link} icon={@link_cs.icon}>
      <%= @link_cs.name %>
    </CustomComponents.link_button> --%>

    <CustomComponents.link_button link={@link_sg.link} icon={@link_sg.icon}>
      <%= @link_sg.name %>
    </CustomComponents.link_button>
    """
  end
end
