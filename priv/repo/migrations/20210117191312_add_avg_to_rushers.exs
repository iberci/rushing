defmodule NflRusher.Repo.Migrations.AddAvgToRushers do
  use Ecto.Migration

  def change do
    alter table("rushers") do
      add :avg, :float, after: :att_g
    end
  end
end
