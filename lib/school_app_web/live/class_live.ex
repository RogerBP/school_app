defmodule SchoolAppWeb.ClassLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.IndexComponent
  alias SchoolAppWeb.CustomComponents

  @app_item :classes

  def mount(_params, _session, socket) do
    link_t = SchoolAppWeb.AppUtils.get_item(:teachers)
    link_tc = SchoolAppWeb.AppUtils.get_item(:teachers_classes)

    {:ok,
     socket
     |> assign(
       link_t: %{
         link: link_t.link,
         icon: link_t.icon,
         name: link_t.name
       },
       link_tc: %{
         link: link_tc.link,
         icon: link_tc.icon,
         name: link_tc.name
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

    <CustomComponents.link_button link={@link_tc.link} icon={@link_tc.icon}>
      <%= @link_tc.name %>
    </CustomComponents.link_button>
    """
  end
end
