defmodule SchoolApp.Repo do
  use Ecto.Repo,
    otp_app: :school_app,
    adapter: Ecto.Adapters.Postgres
end
