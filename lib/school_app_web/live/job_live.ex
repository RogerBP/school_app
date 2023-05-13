defmodule SchoolAppWeb.JobLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.IndexComponent

  @app_item :jobs

  def mount(_params, _session, socket) do
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
    """
  end
end
