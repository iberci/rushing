defmodule NflRusher.Repo.Migrations.CreateRushers do
  use Ecto.Migration

  def change do
    create table(:rusher_versions) do
      add :name, :string, null: false
      add :started_at, :utc_datetime
      add :completed_at, :utc_datetime
      add :faulted_at, :utc_datetime
      add :faulted_text, :text
      add :file_sha256, :string

      timestamps()
    end

    create table(:rushers) do
      add :rusher_version_id, references(:rusher_versions, on_delete: :delete_all)
      add :team, :string, null: false
      add :pos, :string, null: false
      add :att, :integer
      add :att_g, :float
      add :yds, :integer
      add :yds_g, :float
      add :td, :integer
      add :lng, :integer
      add :lng_td, :boolean, default: false, null: false
      add :fd, :integer
      add :fd_p, :integer
      add :plus_20, :integer
      add :plus_40, :integer
      add :fumbles, :integer
    end

    create table(:rusher_names) do 
      add :rusher_id, references(:rushers, on_delete: :delete_all)
      add :ordinal, :integer
      add :name, :string
      add :index_name, :string
    end
  end
end
