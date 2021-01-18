defmodule NflRusher.Repo.Migrations.AddImportPathToRusherVersions do
  use Ecto.Migration

  def change do
    alter table("rusher_versions") do
      add :import_path, :string
    end

  end
end
