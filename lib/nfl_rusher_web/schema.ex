defmodule NflRusherWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Plug.Types

  alias NflRusher.ResolverRushers
  alias NflRusher.ResolverImportJSONFile

  object :rusher do
    field :id, non_null(:id)
    field :player, non_null(:string)
    field :att, non_null(:integer)
    field :att_g, non_null(:float)
    field :fd, non_null(:integer)
    field :fd_p, non_null(:float)
    field :lng, non_null(:string)
    field :plus_20, non_null(:integer)
    field :plus_40, non_null(:integer)
    field :pos, non_null(:string)
    field :td, non_null(:integer)
    field :team, non_null(:string)
    field :yds, non_null(:integer)
    field :yds_g, non_null(:float)
    field :fum, non_null(:integer)
  end

  enum :rusher_field do
    value :player, description: "Player"
    value :att, description: "Attempts"
    value :att_g, description: "Attempts/Game"
    value :fd, description: "First Downs"
    value :fd_p, description: "First Down Percentage"
    value :lng, description: "Longest (T denotes a TD)"
    value :plus_20, description: "20+ yards"
    value :plus_40, description: "40+ yards"
    value :pos, description: "Position"
    value :td, description: "Touch Downs"
    value :team, description: "Team"
    value :yds, description: "Yards"
    value :yds_g, description: "Yards/Game"
    value :fum, description: "Fumbles"
  end

  input_object :input_rushers_order do
    field :field, non_null(:rusher_field)
    field :dir, :boolean
  end

  input_object :input_rushers do
    field :order, :input_rushers_order
    field :offset, :integer
    field :limit, :integer
    field :search, :string
  end

  object :payload_rushers do
    field :rushers, non_null(list_of(:rusher))
  end

  input_object :input_import_json_file do
    field :file, non_null(:upload)
    field :name, :string
  end

  object :payload_import_json_file do
    field :version_id, :id
    field :version_name, :string
  end

  query do
    field :rushers, non_null(:payload_rushers) do
      arg :input, non_null(:input_rushers)
      resolve &ResolverRushers.resolve/3
    end
  end

  mutation do
    
    @desc "Imports a JSON file"
    field :import_json_file, non_null(:payload_import_json_file) do
      arg :input, non_null(:input_import_json_file)
      resolve &ResolverImportJsonRile.resolve/3
    end
  end
end
