defmodule SchoolAppWeb.RateLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.CustomComponents
  alias SchoolApp.DbWeb
  alias SchoolApp.Students
  # alias SchoolApp.Rate

  def mount(_params, _session, socket) do
    link_ass = SchoolAppWeb.AppUtils.get_item(:assessments)

    options = %{
      teacher_id: 0,
      grade_id: 0,
      class_id: 0,
      student_id: 0,
      student_count: 0,
      selected_student: nil
    }

    socket =
      assign(socket,
        options: options,
        selected_teacher: nil,
        selected_domain: nil,
        selected_goal: nil,
        selected_rate_value: -999,
        teacher_list: DbWeb.teacher_list(),
        grade_list: [],
        class_list: [],
        domain_list: [],
        goal_list: [],
        student_list: [],
        link_ass: link_ass
      )

    {:ok, socket, temporary_assigns: [student_list: []]}
  end

  def render(assigns) do
    ~H"""
    <CustomComponents.panel_header icon={@link_ass.icon}>Assesments</CustomComponents.panel_header>
    <div class="w-full gap-1 flex flex-wrap">
      <div :if={!@options.selected_student} class="w-full rounded border p-2 flex gap-2 bg-slate-200">
        <div :if={length(@teacher_list) == 0}>
          <div class="">Teacher:</div>

          <div :if={@selected_teacher} class="font-black">
            <%= @options.selected_teacher.name %>
          </div>
        </div>

        <div :if={length(@teacher_list) > 0} class="w-full">
          <form>
            <CustomComponents.input_teacher
              teacher_id={@options.teacher_id}
              teacher_list={@teacher_list}
              on_change="teacher-change"
            />
          </form>
        </div>
      </div>

      <div :if={!@options.selected_student} class="w-full gap-1 flex flex-wrap">
        <div class="rounded border p-2 w-full bg-slate-200">
          <form>
            <div class="flex gap-2">
              <div class="w-1/2">
                <CustomComponents.input_grade
                  on_change="grade-change"
                  grade_id={@options.grade_id}
                  grade_list={@grade_list}
                />
              </div>

              <div class="w-1/2">
                <CustomComponents.input_class
                  on_change="class-change"
                  class_id={@options.class_id}
                  class_list={@class_list}
                />
              </div>
            </div>
          </form>
        </div>

        <div
          :if={@options.student_count > 0}
          class="items-center justify-center p-4 w-full flex flex-wrap gap-1"
        >
          <div :for={student <- @student_list}>
            <CustomComponents.mini_card
              on_click="avatar-click"
              click_value={student.id}
              avatar={student.avatar}
              name={student.name}
            />
          </div>
        </div>
      </div>

      <div :if={@options.selected_student} class="w-full flex ">
        <CustomComponents.mini_card
          on_click="avatar-return"
          avatar={@options.selected_student.avatar}
          name={@options.selected_student.name}
        />
        <div :if={!@selected_domain} class="w-full">
          <button
            :for={domain <- @domain_list}
            :if={!@selected_domain}
            phx-click="domain-click"
            phx-value-domain_id={domain.id}
            phx-value-domain_name={domain.name}
            class="border rounded h-8 w-1/2 bg-slate-300"
          >
            <%= domain.name %>
          </button>
        </div>

        <div :if={@selected_domain} class="w-full">
          <button class="w-full border rounded h-8 bg-slate-300 ">
            <%= @selected_domain.name %>
          </button>

          <button
            :for={goal <- @goal_list}
            :if={!@selected_goal}
            phx-click="goal-click"
            phx-value-goal_id={goal.id}
            phx-value-goal_name={goal.name}
            class="w-full p-1 border rounded bg-orange-100"
          >
            <%= goal.name %>
          </button>

          <div :if={@selected_goal} class="w-full">
            <button class="w-full p-1 border rounded bg-orange-100">
              <%= @selected_goal.name %>
            </button>

            <div class="justify-center w-full flex p-2 gap-4">
              <button
                :if={@selected_rate_value in [-1, -999]}
                phx-click={get_rate_click(@selected_rate_value)}
                phx-value-rate="-1"
                class="h-20 w-20 rounded border p-2 bg-stone-200"
              >
                <.icon name="hero-hand-thumb-down" class="h-16 w-16 bg-red-500 hover:animate-bounce" />
              </button>

              <button
                :if={@selected_rate_value in [0, -999]}
                phx-click={get_rate_click(@selected_rate_value)}
                phx-value-rate="0"
                class="h-20 w-20 rounded border p-2 bg-stone-200"
              >
                <.icon name="hero-no-symbol" class="h-16 w-16 hover:animate-bounce" />
              </button>

              <button
                :if={@selected_rate_value in [1, -999]}
                phx-click={get_rate_click(@selected_rate_value)}
                phx-value-rate="1"
                class="h-20 w-20 rounded border p-2 bg-stone-200"
              >
                <.icon name="hero-hand-thumb-up" class="h-16 w-16 bg-blue-500 hover:animate-bounce" />
              </button>
            </div>
          </div>
        </div>
      </div>

      <pre>
        <%= inspect @options.selected_student, pretty: true  %>
        <%= inspect @domain_list, pretty: true  %>
        <%= inspect @goal_list, pretty: true  %>

      </pre>
    </div>
    """
  end

  def get_rate_click(-999), do: "rate-click"
  def get_rate_click(_), do: "rate-return"

  def handle_event("rate-return", _, socket) do
    options = %{socket.assigns.options | student_id: 0, selected_student: nil}

    socket =
      assign(socket,
        options: options,
        selected_domain: nil,
        selected_goal: nil,
        selected_rate_value: -999,
        domain_list: [],
        goal_list: []
      )

    socket = load_student_list(socket)

    {:noreply, socket}
  end

  def handle_event("rate-click", %{"rate" => value}, socket) do
    value = String.to_integer(value)
    options = socket.assigns.options

    rate = %{
      student_id: options.selected_student.id,
      student_goal_id: socket.assigns.selected_goal.id,
      domain_id: socket.assigns.selected_domain.id,
      grade_id: options.selected_student.grade_id,
      teacher_id: options.teacher_id,
      value: value
    }

    IO.inspect(SchoolApp.Assessments.create_assessment(rate))

    socket = assign(socket, selected_rate_value: value)

    {:noreply, socket}
  end

  def handle_event("goal-click", %{"goal_id" => goal_id, "goal_name" => goal_name}, socket) do
    goal_id = String.to_integer(goal_id)

    socket =
      assign(socket,
        selected_goal: %{id: goal_id, name: goal_name},
        selected_rate_value: -999
      )

    {:noreply, socket}
  end

  def handle_event(
        "domain-click",
        %{"domain_id" => domain_id, "domain_name" => domain_name},
        socket
      ) do
    domain_id = String.to_integer(domain_id)

    goal_list =
      SchoolApp.Db.goals_by_student_domain(socket.assigns.options.selected_student.id, domain_id)

    socket =
      assign(socket,
        selected_domain: %{id: domain_id, name: domain_name},
        goal_list: goal_list,
        selected_goal: nil
      )

    {:noreply, socket}
  end

  def handle_event("avatar-click", %{"data" => student_id}, socket) do
    student_id = String.to_integer(student_id)
    options = %{socket.assigns.options | selected_student: Students.get_record!(student_id)}
    domain_list = SchoolApp.Db.domains_by_student(student_id)

    socket =
      assign(socket,
        options: options,
        domain_list: domain_list,
        selected_domain: nil
      )

    {:noreply, socket}
  end

  def handle_event("avatar-return", _, socket) do
    options = %{socket.assigns.options | selected_student: nil}
    socket = assign(socket, options: options)
    socket = load_student_list(socket)
    {:noreply, socket}
  end

  def handle_event("teacher-change", %{"teacher_id" => teacher_id}, socket) do
    teacher_id = String.to_integer(teacher_id)
    options = %{socket.assigns.options | teacher_id: teacher_id}
    socket = assign(socket, options: options)
    socket = load_teacher(socket)
    {:noreply, socket}
  end

  def handle_event("grade-change", %{"grade_id" => grade_id}, socket) do
    grade_id = String.to_integer(grade_id)
    options = %{socket.assigns.options | grade_id: grade_id}
    socket = assign(socket, options: options)
    socket = load_student_list(socket)
    {:noreply, socket}
  end

  def handle_event("class-change", %{"class_id" => class_id}, socket) do
    class_id = String.to_integer(class_id)
    options = %{socket.assigns.options | class_id: class_id}
    socket = assign(socket, options: options)
    socket = load_student_list(socket)
    {:noreply, socket}
  end

  def load_student_list(socket) do
    options = socket.assigns.options

    student_list =
      SchoolApp.Db.student_list(options.teacher_id, options.class_id, options.grade_id)

    options = %{options | student_count: length(student_list)}
    assign(socket, student_list: student_list, options: options)
  end

  defp load_teacher(socket) do
    teacher_id = socket.assigns.options.teacher_id
    grade_list = DbWeb.grade_list_by_teacher(teacher_id)
    class_list = DbWeb.class_list_by_teacher(teacher_id)
    options = %{socket.assigns.options | grade_id: 0}
    options = %{options | class_id: 0}
    options = %{options | student_id: 0}
    options = %{options | student_count: 0}
    options = %{options | selected_student: nil}

    socket =
      assign(socket,
        options: options,
        grade_list: grade_list,
        class_list: class_list
      )

    load_student_list(socket)
  end
end
