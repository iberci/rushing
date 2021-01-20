defmodule NflRusher.Repo.Migrations.ProperIndexingForRusherNames do
  use Ecto.Migration

  def change do

    alter table("rusher_names") do
      modify(:rusher_id, :integer, null: false)

      references(:rusher_versions, on_delete: :delete_all) 
    end

    create index("rusher_names", [:name])
    create index("rushers", [:team])
    create index("rushers", [:pos])
    create index("rushers", [:att])
    create index("rushers", [:att_g])
    create index("rushers", [:yds])
    create index("rushers", [:yds_g])
    create index("rushers", [:td])
    create index("rushers", [:lng])
    create index("rushers", [:lng_td])
    create index("rushers", [:fd])
    create index("rushers", [:fd_p])
    create index("rushers", [:plus_20])
    create index("rushers", [:plus_40])
    create index("rushers", [:fum])
    create index("rushers", [:player])
    create index("rushers", [:avg])
 
  end
end
