defmodule NflRusher.RusherImporter do

  def import(file_path) do
    file_path
      |> read_file
      |> Enum.map(&import_rusher/1)
  end

  defp read_file(file_path) do
    {:ok, rusher_data} = File.read(file_path)

    {:ok, decoded} = JSON.decode!(rusher_data)
    decoded
  end

  defp import_rusher(%{} = data) do
    %{
      player: data["Player"],
      team: data["Team"],
      pos: data["Pos"],
      att: data["Att"],
      att_g: data["Att/G"],
      yds: data["Yds"],
      yds_g: data["Yds/G"],
      td: data["TD"],
      lng: read_lng(data["Lng"]),
      lng_td: read_lng_td(data["Lng"]),
      fd: data["1st"],
      fd_p: data["1st%"],
      plus_20: data["20+"],
      plus_40: data["40+"],
      fum: data["FUM"]
    }
  end

  defp read_lng(field) do
  end

  defp read_lng_td(field) do
  end
end
