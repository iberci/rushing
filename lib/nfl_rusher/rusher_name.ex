defmodule NflRusher.RusherName do
  use Ecto.Schema
  import Ecto.Changeset
  alias NflRusher.Rusher

  schema "rusher_names" do
    belongs_to :rusher, Rusher
    field :ordinal, :integer 
    field :name, :string
    field :index_name, :string
  end

  def changeset(cs, attrs) do
    cs
      |> cast(attrs, [:ordinal, :name])
      |> validate_required([:ordinal, :name])
      |> set_index_name
  end

  defp set_index_name(cs) do
    index_name = get_field(cs, :name)
      |> String.downcase
    cs
      |> put_change(:index_name, index_name)
  end
end
