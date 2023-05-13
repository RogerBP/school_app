defmodule SchoolAppWeb.CourseLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.IndexComponent
  alias SchoolAppWeb.AppUtils
  alias SchoolAppWeb.CustomComponents

  @app_item :courses

  def mount(_params, _session, socket) do
    link_cs = AppUtils.get_item(:courses_segments)
    link_sg = AppUtils.get_item(:segments)

    {:ok,
     socket
     |> assign(
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
    />

    <%!-- <pre><%= inspect @link_cs, pretty: true %></pre> --%>
    <CustomComponents.link_button link={@link_sg.link} icon={@link_sg.icon}>
      <%= @link_sg.name %>
    </CustomComponents.link_button>
    <CustomComponents.link_button link={@link_cs.link} icon={@link_cs.icon}>
      <%= @link_cs.name %>
    </CustomComponents.link_button>
    """
  end
end
