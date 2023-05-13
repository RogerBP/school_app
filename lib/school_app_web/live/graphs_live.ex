defmodule SchoolAppWeb.GraphsLive do
  use SchoolAppWeb, :live_view
  # alias SchoolAppWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        options: get_options(%{}),
        chart_data: nil,
        grade_list: grade_list(0),
        class_list: class_list(0),
        student_list: [],
        goal_list: goal_list(0),
        chartted: false
      )

    {:ok, socket, temporary_assigns: [chart_data: nil]}
  end

  def render(assigns) do
    ~H"""
    <.header>Charts</.header>

    <%!--
    <form phx-submit="submit-graph" phx-change="change-graph">
      <div class="rounded border p-4 grid gap-y-1 grid-cols-1">
        <CustomComponents.input_dates
          on_change=""
          date_start={@options.date_start}
          date_end={@options.date_end}
        />
        <div class="flex gap-2">
          <div class="w-full">
            <CustomComponents.input_teacher
              teacher_id={@options.teacher_id}
              teacher_list={teacher_list_options()}
            />
          </div>
        </div>
    
        <div class="flex gap-2">
          <div class="w-1/2">
            <CustomComponents.input_grade grade_id={@options.grade_id} grade_list={@grade_list} />
          </div>
    
          <div class="w-1/2">
            <CustomComponents.input_class class_id={@options.class_id} class_list={@class_list} />
          </div>
        </div>
    
        <div class="flex gap-2">
          <div class="w-1/2">
            <CustomComponents.input_student
              student_id={@options.student_id}
              student_list={@student_list}
            />
          </div>
    
          <div class="w-1/2">
            <CustomComponents.input_goal goal_id={@options.goal_id} goal_list={@goal_list} />
          </div>
        </div>
    
        <div>
          <.button>Execute</.button>
        </div>
      </div>
    </form>
    
    <div id="assessments" class="assessments">
      <div :if={@chart_data} phx-update="ignore" id="div-canvas">
        <canvas id="chart-canvas" phx-hook="LineChart" data-chart-data={Jason.encode!(@chart_data)}>
        </canvas>
      </div>
    </div> --%>
    """
  end

  def send_chart_data(socket, chart_data, false), do: assign(socket, chart_data: chart_data)

  def send_chart_data(socket, chart_data, true) do
    IO.puts("==============> send_chart_data(socket, chart_data, _) ")
    push_event(socket, "load_data", chart_data)
  end

  def handle_event("submit-graph", params, socket) do
    chartted = socket.assigns.chartted
    options = get_options(params)

    # {:ok, date_start} = Timex.parse(options.date_start, "{YYYY}-{M}-{D}")
    # {:ok, date_end} = Timex.parse(options.date_end, "{YYYY}-{M}-{D}")

    chart_data = SchoolApp.GraphUtils.load_dataset(options)
    socket = assign(socket, options: options)
    socket = send_chart_data(socket, chart_data, chartted)
    socket = assign(socket, chartted: true)

    {:noreply, socket}
  end

  def handle_event("change-graph", %{"_target" => [target | _]} = params, socket) do
    # %{
    #   "_target" => ["date_start"],
    #   "class_id" => "0",
    #   "date_end" => "",
    #   "date_start" => "01/01/2022",
    #   "goal_id" => "0",
    #   "grade_id" => "0",
    #   "student_id" => "0",
    #   "teacher_id" => "13"
    # }
    options = get_options(params)
    socket = assign(socket, options: options)
    socket = change(socket, options, target)

    {:noreply, socket}
  end

  def change(socket, options, "teacher_id") do
    options = %{options | grade_id: 0, class_id: 0, student_id: 0}

    assign(socket,
      grade_list: grade_list(options.teacher_id),
      class_list: class_list(options.teacher_id),
      student_list: [],
      options: options
    )
  end

  def change(socket, options, "grade_id") do
    options = %{options | student_id: 0}

    assign(socket,
      grade_id: options.grade_id,
      student_list: student_list(0, 0, options.grade_id),
      options: options
    )
  end

  def change(socket, options, "student_id") do
    options = %{options | goal_id: 0}

    assign(socket,
      student_id: options.student_id,
      goal_list: goal_list(options.student_id),
      options: options
    )
  end

  def change(socket, _options, target) do
    IO.puts("==========> CHANGE IGNORADO: #{target}")
    socket
  end

  # defp teacher_list_options do
  #   SchoolApp.Teachers.list()
  #   |> Enum.sort(&(&1.name <= &2.name))
  #   |> Enum.map(&{&1.name, &1.id})
  # end

  defp grade_list(0) do
    SchoolApp.Grades.list()
    |> Enum.sort(&(&1.id <= &2.id))
    |> Enum.map(&{&1.name, &1.id})
  end

  defp grade_list(teacher_id) do
    SchoolApp.TeachersGrades.list(%{teacher_id: teacher_id})
    |> SchoolApp.TeachersGrades.load_grades()
    |> Enum.sort(&(&1.grade_id <= &2.grade_id))
    |> Enum.map(&{&1.grade.name, &1.grade_id})
  end

  defp class_list(0) do
    IO.puts("========> class_list(0) <============")

    SchoolApp.Classes.list()
    |> Enum.sort(&(&1.id <= &2.id))
    |> Enum.map(&{&1.code, &1.id})
  end

  defp class_list(teacher_id) do
    IO.puts("========> class_list(teacher_id) <============")

    SchoolApp.TeachersClasses.list(%{teacher_id: teacher_id})
    |> SchoolApp.TeachersClasses.load_classes()
    |> Enum.sort(&(&1.class.code <= &2.class.code))
    |> Enum.map(&{&1.class.code, &1.class.id})
  end

  defp student_list(_teacher_id, _class_id, _grade_id) do
    # SchoolApp.Students.list(%{
    #   teacher_id: teacher_id,
    #   lass_id: class_id,
    #   grade_id: grade_id
    # })
    # |> Enum.sort(&(&1.name <= &2.name))
    # |> Enum.map(&{&1.name, &1.id})
  end

  defp goal_list(0) do
    SchoolApp.Goals.list()
    |> Enum.sort(&(&1.name <= &2.name))
    |> Enum.map(&{&1.name, &1.id})
  end

  defp goal_list(student_id) do
    SchoolApp.StudentsGoals.list(%{student_id: student_id})
    |> SchoolApp.StudentsGoals.load_goals()
    |> Enum.sort(&(&1.goal.name <= &2.goal.name))
    |> Enum.map(&{&1.goal.name, &1.goal_id})
  end

  defp get_options(params) do
    # params
    # %{
    #   "class" => "0",
    #   "date_end" => "01/31/2022",
    #   "date_start" => "01/01/2022",
    #   "goal" => "0",
    #   "grade" => "0",
    #   "student" => "0",
    #   "teacher" => "14"
    # }

    %{
      date_start: params["date_start"] || "",
      date_end: params["date_end"] || "",
      teacher_id: (params["teacher_id"] || "0") |> String.to_integer(),
      class_id: (params["class_id"] || "0") |> String.to_integer(),
      grade_id: (params["grade_id"] || "0") |> String.to_integer(),
      student_id: (params["student_id"] || "0") |> String.to_integer(),
      goal_id: (params["goal_id"] || "0") |> String.to_integer()
    }
  end
end
