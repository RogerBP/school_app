defmodule SchoolAppWeb.HomeLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.AppUtils
  alias SchoolAppWeb.CustomComponents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <CustomComponents.link_button :for={i <- AppUtils.main_menu_itens()} link={i.link} icon={i.icon}>
      <%= i.name %>
    </CustomComponents.link_button>
    """
  end
end
