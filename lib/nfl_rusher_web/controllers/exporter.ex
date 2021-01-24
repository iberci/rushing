defmodule NflRusherWeb.Exporter do
  use NflRusherWeb, :controller
  import Ecto.Query
  alias NflRusher.{RusherVersion, Rusher, Repo}

  def export_csv(conn, _assigns) do

    path = create_file!()
    conn = send_download(conn, {:file, path})

    File.rm(path)

    conn
  end

  def create_file! do

    version = current_version()

    filename = Path.join("exports/" ,"#{version.name}-#{DateTime.utc_now |> DateTime.truncate(:second)}.csv")
    
    File.open!(filename, [:write, :utf8], fn(file) ->
      file 
        |> add_rushers(version)
    end)

    filename
  end

  defp add_rushers(file, version) do
    version
      |> get_rushers
      |> Enum.map(fn(rusher) -> encode_rusher(rusher, file) end)
  end

  defp encode_rusher(rusher, file) do
    lng = case(rusher.lng_td) do
      true ->
        "#{rusher.lng}T"
      false ->
        "#{rusher.lng}"
    end

    [ 
     [:att, rusher.att],
     [:att_g, rusher.att_g],
     [:avg, rusher.avg],
     [:fd, rusher.fd],
     [:fp_p, rusher.fd_p],
     [:fum, rusher.fum],
     [:lng, lng],
     [:player, rusher.player],
     [:plus_20, rusher.plus_20],
     [:plus_40, rusher.plus_40],
     [:pos, rusher.pos],
     [:td, rusher.td],
     [:team, rusher.team],
     [:yds, rusher.yds],
     [:yds_g, rusher.yds_g]
    ] |> CSV.encode |> Enum.each(&IO.write(file, &1))
  end

  defp get_rushers(version) do
    (from r in Rusher,
    join: rv in assoc(r, :rusher_version),
    where: rv.id == ^version.id,
    order_by: r.player) 
      |> Repo.all()
  end

  defp current_version do
    (from rv in RusherVersion,
    where: not is_nil(rv.completed_at),
    limit: 1,
    order_by: [desc: rv.completed_at])
     |> Repo.one()
  end
end
