defmodule NflRusher.Repo do
  use Ecto.Repo,
    otp_app: :nfl_rusher,
    adapter: Ecto.Adapters.Postgres
end
