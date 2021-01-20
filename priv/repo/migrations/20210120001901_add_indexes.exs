defmodule NflRusher.Repo.Migrations.AddIndexes do
  use Ecto.Migration

  def change do

    alter table("rushers") do
      modify(:rusher_version_id, :integer, null: false)
      references(:rusher_versions, on_delete: :delete_all) 
    end

  end
end
