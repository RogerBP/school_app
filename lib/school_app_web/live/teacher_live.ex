defmodule SchoolAppWeb.TeacherLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.IndexComponent
  alias SchoolAppWeb.CustomComponents

  @app_item :teachers

  def mount(_params, _session, socket) do
    link_cl = SchoolAppWeb.AppUtils.get_item(:classes)
    link_gr = SchoolAppWeb.AppUtils.get_item(:grades)
    link_tc = SchoolAppWeb.AppUtils.get_item(:teachers_classes)
    link_tg = SchoolAppWeb.AppUtils.get_item(:teachers_grades)

    {:ok,
     assign(socket,
       link_cl: %{
         link: link_cl.link,
         icon: link_cl.icon,
         name: link_cl.name
       },
       link_gr: %{
         link: link_gr.link,
         icon: link_gr.icon,
         name: link_gr.name
       },
       link_tc: %{
         link: link_tc.link,
         icon: link_tc.icon,
         name: link_tc.name
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

    <CustomComponents.link_button link={@link_cl.link} icon={@link_cl.icon}>
      <%= @link_cl.name %>
    </CustomComponents.link_button>

    <CustomComponents.link_button link={@link_gr.link} icon={@link_gr.icon}>
      <%= @link_gr.name %>
    </CustomComponents.link_button>

    <CustomComponents.link_button link={@link_tc.link} icon={@link_tc.icon}>
      <%= @link_tc.name %>
    </CustomComponents.link_button>

    <CustomComponents.link_button link={@link_tg.link} icon={@link_tg.icon}>
      <%= @link_tg.name %>
    </CustomComponents.link_button>
    """
  end
end
