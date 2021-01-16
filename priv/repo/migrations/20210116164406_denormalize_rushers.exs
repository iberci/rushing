defmodule NflRusher.Repo.Migrations.DenormalizeRushers do
  use Ecto.Migration

  def change do
    rename table("rushers"), :fumbles, to: :fum

    alter table("rushers") do 
      add :player, :string, after: :id, null: false
    end

  end
end
