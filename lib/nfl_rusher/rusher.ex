defmodule NflRusher.Rusher do
  use Ecto.Schema
  import Ecto.Changeset
  alias NflRusher.{RusherVersion, RusherName}

  schema "rushers" do
    belongs_to :rusher_version, RusherVersion
    has_many :rusher_names, RusherName
    field :player, :string
    field :att, :integer
    field :att_g, :float
    field :fd, :integer
    field :fd_p, :float
    field :lng, :integer
    field :lng_td, :boolean, default: false
    field :plus_20, :integer
    field :plus_40, :integer
    field :pos, :string
    field :td, :integer
    field :team, :string
    field :yds, :integer
    field :yds_g, :float
    field :fum, :integer
  end

  @doc false
  def changeset(rusher, attrs) do
    rusher
    |> cast(attrs, [:player, :team, :pos, :att, :att_g, :yds, :yds_g, :td, :lng, :lng_td, :fd, :fd_p, :plus_20, :plus_40, :fum])
    |> validate_required([:player, :team, :pos, :att, :att_g, :yds, :yds_g, :td, :lng, :lng_td, :fd, :fd_p, :plus_20, :plus_40, :fum])

    |> set_names
  end

  defp set_names(cs) do

    player = get_field(cs, :player)

    if(player) do
      rusher_names = Regex.split(~r/[\s,]+/, player)
        |> Enum.with_index(1)
        |> Enum.map(fn {name, ordinal}-> %RusherName{name: name, ordinal: ordinal} end)
     
      put_change(cs, :rusher_names,  rusher_names)
    else
      cs
    end
  end
end
