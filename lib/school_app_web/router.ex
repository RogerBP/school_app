defmodule SchoolAppWeb.Router do
  use SchoolAppWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {SchoolAppWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SchoolAppWeb do
    pipe_through(:browser)

    live("/", HomeLive)
    live("/rate", RateLive)
    live("/graphs", GraphsLive)

    live("/courses", CourseLive, :index)
    live("/courses/new", CourseLive, :new)
    live("/courses/:id/edit", CourseLive, :edit)

    live("/segments", SegmentLive, :index)
    live("/segments/new", SegmentLive, :new)
    live("/segments/:id/edit", SegmentLive, :edit)

    live("/courses_segments", CourseSegmentLive, :index)
    live("/courses_segments/new", CourseSegmentLive, :new)

    live("/jobs", JobLive, :index)
    live("/jobs/new", JobLive, :new)
    live("/jobs/:id/edit", JobLive, :edit)

    live("/teachers", TeacherLive, :index)
    live("/teachers/new", TeacherLive, :new)
    live("/teachers/:id/edit", TeacherLive, :edit)

    live("/classes", ClassLive, :index)
    live("/classes/new", ClassLive, :new)
    live("/classes/:id/edit", ClassLive, :edit)

    live("/grades", GradeLive, :index)
    live("/grades/new", GradeLive, :new)
    live("/grades/:id/edit", GradeLive, :edit)

    live("/teachers_classes", TeacherClassLive, :index)
    live("/teachers_classes/new", TeacherClassLive, :new)

    live("/teachers_grades", TeacherGradeLive, :index)
    live("/teachers_grades/new", TeacherGradeLive, :new)

    live("/domains", DomainLive, :index)
    live("/domains/new", DomainLive, :new)
    live("/domains/:id/edit", DomainLive, :edit)

    live("/goals", GoalLive, :index)
    live("/goals/new", GoalLive, :new)
    live("/goals/:id/edit", GoalLive, :edit)

    live("/students", StudentLive, :index)
    live("/students/new", StudentLive, :new)
    live("/students/:id/edit", StudentLive, :edit)

    # live("/students_domains", StudentDomainLive, :index)
    # live("/students_domains/new", StudentDomainLive, :new)

    live("/students_goals", StudentGoalLive, :index)
    live("/students_goals/new", StudentGoalLive, :new)
  end

  # Other scopes may use custom stacks.
  # scope "/api", SchoolAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:school_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: SchoolAppWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
