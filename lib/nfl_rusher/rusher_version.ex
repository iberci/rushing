defmodule NflRusher.RusherVersion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rusher_versions" do
    has_many :rushers, Rusher
    field :name, :string
    field :started_at, :utc_datetime
    field :completed_at, :utc_datetime
    field :faulted_at, :utc_datetime
    field :faulted_text, :text
    field :file_sha256, :string
  end
end
