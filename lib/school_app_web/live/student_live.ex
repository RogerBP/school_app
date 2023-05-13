defmodule SchoolAppWeb.StudentLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.IndexComponent
  alias SchoolAppWeb.CustomComponents

  @app_item :students

  def mount(_params, _session, socket) do
    link_sg = SchoolAppWeb.AppUtils.get_item(:students_goals)
    link_goals = SchoolAppWeb.AppUtils.get_item(:goals)

    socket =
      assign(socket,
        link_sg: %{
          link: link_sg.link,
          icon: link_sg.icon,
          name: link_sg.name
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
    <.live_component
      module={IndexComponent}
      id={"#{@app_item}-index"}
      app_item={@app_item}
      live_action={@live_action}
      params={@params}
    />

    <CustomComponents.link_button link={@link_sg.link} icon={@link_sg.icon}>
      <%= @link_sg.name %>
    </CustomComponents.link_button>
    <CustomComponents.link_button link={@link_goals.link} icon={@link_goals.icon}>
      <%= @link_goals.name %>
    </CustomComponents.link_button>
    """
  end
end
