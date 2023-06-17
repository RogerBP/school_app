defmodule SchoolAppWeb.StudentLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.IndexComponent
  alias SchoolAppWeb.CustomComponents

  @app_item :students

  def mount(_params, _session, socket) do
    grade_list = SchoolApp.Grades.web_options_list()

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
        },
        grade_list: grade_list,
        grade_id: 0,
        filter: %{}
      )

    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    IO.inspect("------------ handle-params -------------")

    {
      :noreply,
      socket
      |> assign(app_item: @app_item)
      |> assign(params: params)
    }
  end

  def render(assigns) do
    ~H"""
    <form>
      <CustomComponents.input_grade
        grade_list={@grade_list}
        grade_id={@grade_id}
        on_change="filter_grade"
      />
    </form>

    <.live_component
      module={IndexComponent}
      id={"#{@app_item}-index"}
      app_item={@app_item}
      live_action={@live_action}
      params={@params}
      filter={@filter}
      display_field_fn={&display_field/3}
    />

    <CustomComponents.link_button link={@link_sg.link} icon={@link_sg.icon}>
      <%= @link_sg.name %>
    </CustomComponents.link_button>
    <CustomComponents.link_button link={@link_goals.link} icon={@link_goals.icon}>
      <%= @link_goals.name %>
    </CustomComponents.link_button>
    """
  end

  def handle_event("filter_grade", %{"grade_id" => grade_id}, socket) do
    id = String.to_integer(grade_id)
    filter = get_grade_filter(id)

    socket =
      assign(socket,
        grade_id: id,
        filter: filter
      )

    {:noreply, socket}
  end

  defp get_grade_filter(0), do: %{}

  defp get_grade_filter(id) do
    %{grade_id: id}
  end

  def display_field(register, :avatar, dado) do
    assigns = %{dado: dado, id: register.id}

    ~H"""
    <div class="w-32 p-1">
      <.link navigate={"/students/#{@id}/avatar" }>
        <img class="rounded-full" src={@dado} />
      </.link>
    </div>
    """
  end

  def display_field(_register, :name, dado) do
    assigns = %{dado: dado}

    ~H"""
    <div class="p-2 font-bold border w-2/3 items-center flex">
      <div>
        <%= @dado %>
      </div>
    </div>
    """
  end

  def display_field(_register, _col, dado) do
    assigns = %{dado: dado}

    ~H"""
    <div class="p-2 font-bold border w-1/3  items-center flex">
      <%= @dado %>
    </div>
    """
  end
end
