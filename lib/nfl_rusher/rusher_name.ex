defmodule NflRusher.RusherName do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rusher_names" do
    belongs_to :rusher, Rusher
    field :ordinal, :integer 
    field :name, :string
    field :index_name, :string
  end

end
