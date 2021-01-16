defmodule NflRusher.Repo.Migrations.FixFdPToFloat do
  use Ecto.Migration

  def change do

    alter table("rushers") do
      modify :fd_p, :float
    end

  end
end
