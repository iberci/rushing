defmodule NflRusher.ResolverRushers do
  @limit 100

  import Ecto.Query
  alias NflRusher.{Repo, Rusher}

  alias NflRusher.{Rusher, RusherVersion}
  def resolve(_parent, args, _resolution) do
    rushers = query_rushers(args)
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
	  join: rv in RusherVersion,
	  where: rv.id == ^version.id, 
          limit: ^limit(options),
          offset: ^offset(options))
        |> order(options)
        |> Repo.all
    end
  end

  defp order(q, _options) do
    (from r in q, order_by: r.player)
  end

  defp limit(%{limit: limit}), do: Enum.min(limit, @limit)
  defp limit(_), do: @limit

  defp offset(%{offset: offset}), do: offset
  defp offset(_), do: 0

end
