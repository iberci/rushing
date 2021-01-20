defmodule NflRusher.ResolverRushers do
  @limit 100

  import Ecto.Query
  alias NflRusher.{Repo, Rusher}

  alias NflRusher.{Rusher, RusherVersion, RusherName}
  def resolve(_parent, %{input: input}, _resolution) do
    rushers = query_rushers(input)
      |> Enum.map(&build_rusher/1)
    
    {:ok, %{rushers: rushers}} 
  end

  defp build_rusher(%Rusher{
    id: id,
    player: player,
    att: att,
    att_g: att_g,
    avg: avg,
    fd: fd,
    fd_p: fd_p,
    lng: lng,
    lng_td: lng_td,
    plus_20: plus_20,
    plus_40: plus_40,
    pos: pos,
    td: td,
    team: team,
    yds: yds,
    yds_g: yds_g,
    fum: fum
  }) do
    %{
      id: id,
      player: player,
      att: att,
      att_g: att_g,
      avg: avg,
      fd: fd,
      fd_p: fd_p,
      lng: build_lng(lng, lng_td),
      plus_20: plus_20,
      plus_40: plus_40,
      pos: pos,
      td: td,
      team: team,
      yds: yds,
      yds_g: yds_g,
      fum: fum
    }
  end

  def latest_version() do
    (from r in RusherVersion, 
      where: not(is_nil(r.completed_at)),
      order_by: r.completed_at)
      |> Repo.one()
  end

  defp build_lng(lng, false), do: lng
  defp build_lng(lng, true), do: "#{lng}T"

  defp query_rushers(options) do
    with nil <- latest_version() do
      []
    else
      version ->
        (from r in Rusher,
	  join: rv in assoc(r, :rusher_version),
	  where: rv.id == ^version.id, 
          limit: ^limit(options),
          offset: ^offset(options))
        |> order(options)
	|> search(options)
        |> Repo.all
    end
  end

  defp search(q, %{search: search}) do
    term = search
      |> String.downcase

    index_term = "%#{search}%"

    (from r in q, 
      join: rn in assoc(r, :rusher_names),
      where: like(rn.index_name, ^index_term))
  end
  defp search(q, _), do: q

  defp limit(%{limit: limit}), do: Enum.min([limit, @limit])
  defp limit(_), do: @limit

  defp offset(%{offset: offset}), do: offset
  defp offset(_), do: 0

  defp direction(%{order: %{dir: :asc}}),  do: :asc
  defp direction(_),  do: :desc

  #TODO simplify
  defp order(q, %{order: %{field: :id}} = options), do: (from r in q,  order_by: [{^direction(options), r.id}])
  defp order(q, %{order: %{field: :player}} = options), do: (from r in q,  order_by: [{^direction(options), r.player}])
  defp order(q, %{order: %{field: :att}} = options), do: (from r in q,  order_by: [{^direction(options), r.att}])
  defp order(q, %{order: %{field: :att_g}} = options), do: (from r in q,  order_by: [{^direction(options), r.att_g}])
  defp order(q, %{order: %{field: :avg}} = options), do: (from r in q,  order_by: [{^direction(options), r.avg}])
  defp order(q, %{order: %{field: :fd}} = options), do: (from r in q,  order_by: [{^direction(options), r.fd}])
  defp order(q, %{order: %{field: :fd_p}} = options), do: (from r in q,  order_by: [{^direction(options), r.fd_p}])
  defp order(q, %{order: %{field: :lng}} = options), do: (from r in q,  order_by: [{^direction(options), r.lng}])
  defp order(q, %{order: %{field: :lng_td}} = options), do: (from r in q,  order_by: [{^direction(options), r.lng_td}])
  defp order(q, %{order: %{field: :plus_20}} = options), do: (from r in q,  order_by: [{^direction(options), r.plus_20}])
  defp order(q, %{order: %{field: :plus_40}} = options), do: (from r in q,  order_by: [{^direction(options), r.plus_40}])
  defp order(q, %{order: %{field: :pos}} = options), do: (from r in q,  order_by: [{^direction(options), r.pos}])
  defp order(q, %{order: %{field: :td}} = options), do: (from r in q,  order_by: [{^direction(options), r.td}])
  defp order(q, %{order: %{field: :team}} = options), do: (from r in q,  order_by: [{^direction(options), r.team}])
  defp order(q, %{order: %{field: :yds}} = options), do: (from r in q,  order_by: [{^direction(options), r.yds}])
  defp order(q, %{order: %{field: :yds_g}} = options), do: (from r in q,  order_by: [{^direction(options), r.yds_g}])
  defp order(q, %{order: %{field: :fum}} = options), do: (from r in q,  order_by: [{^direction(options), r.fum}])
 

end
