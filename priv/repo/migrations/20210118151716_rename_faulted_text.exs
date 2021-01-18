defmodule NflRusher.Repo.Migrations.RenameFaultedText do
  use Ecto.Migration

  def change do

    rename(table("rusher_versions"), :faulted_text,to: :faulted_reason) 

  end
end
