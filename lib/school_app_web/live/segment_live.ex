defmodule SchoolAppWeb.SegmentLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.IndexComponent
  alias SchoolAppWeb.CustomComponents
  alias SchoolAppWeb.AppUtils

  @app_item :segments

  def mount(_params, _session, socket) do
    link_co = AppUtils.get_item(:courses)
    link_cs = AppUtils.get_item(:courses_segments)

    {:ok,
     socket
     |> assign(
       link_cs: %{
         link: link_cs.link,
         icon: link_cs.icon,
         name: link_cs.name
       },
       link_co: %{
         link: link_co.link,
         icon: link_co.icon,
         name: link_co.name
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
    <CustomComponents.link_button link={@link_co.link} icon={@link_co.icon}>
      <%= @link_co.name %>
    </CustomComponents.link_button>
    <CustomComponents.link_button link={@link_cs.link} icon={@link_cs.icon}>
      <%= @link_cs.name %>
    </CustomComponents.link_button>
    """
  end
end
