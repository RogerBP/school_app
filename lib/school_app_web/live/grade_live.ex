defmodule SchoolAppWeb.GradeLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.IndexComponent
  alias SchoolAppWeb.CustomComponents

  @app_item :grades

  def mount(_params, _session, socket) do
    link_t = SchoolAppWeb.AppUtils.get_item(:teachers)
    link_tg = SchoolAppWeb.AppUtils.get_item(:teachers_grades)

    {:ok,
     socket
     |> assign(
       link_t: %{
         link: link_t.link,
         icon: link_t.icon,
         name: link_t.name
       },
       link_tg: %{
         link: link_tg.link,
         icon: link_tg.icon,
         name: link_tg.name
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

    <CustomComponents.link_button link={@link_t.link} icon={@link_t.icon}>
      <%= @link_t.name %>
    </CustomComponents.link_button>

    <CustomComponents.link_button link={@link_tg.link} icon={@link_tg.icon}>
      <%= @link_tg.name %>
    </CustomComponents.link_button>
    """
  end
end
