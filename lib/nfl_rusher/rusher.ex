defmodule NflRusher.Rusher do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rushers" do
    belongs_to :rusher_version, RusherVersion
    has_many :rusher_names, RusherName
    field :att, :integer
    field :att_g, :float
    field :fd, :integer
    field :fd_p, :integer
    field :fumbles, :integer
    field :lng, :integer
    field :lng_td, :boolean, default: false
    field :plus_20, :integer
    field :plus_40, :integer
    field :pos, :string
    field :td, :integer
    field :team, :string
    field :yds, :integer
    field :yds_g, :float

    timestamps()
  end

  @doc false
  def changeset(rusher, attrs) do
    rusher
    |> cast(attrs, [:team, :pos, :att, :att_g, :yds, :yds_g, :td, :lng, :lng_td, :fd, :fd_p, :plus_20, :plus_40, :fumbles])
    |> validate_required([:team, :pos, :att, :att_g, :yds, :yds_g, :td, :lng, :lng_td, :fd, :fd_p, :plus_20, :plus_40, :fumbles])
  end
end
