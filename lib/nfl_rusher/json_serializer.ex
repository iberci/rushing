defmodule NflRusher.JsonSerializer do

  alias NflRusher.Rusher
  alias NflRusher.{Repo, RusherVersion}

  def import(file_path, name \\ nil) do

    version = create_version!(file_path, name)
   
    try do
      process_rushers(version, file_path)
      process_finish(version)
      {:ok, version}
    rescue
      e in RuntimeError ->
        report_fault(version, e.message)
        {:error, e}
    end
  end

  defp report_fault(version, message) do
    RusherVersion.changeset_fault(version, %{
      faulted_reason: message
    }) |> Repo.update!
  end

  defp process_finish(version) do
    RusherVersion.changeset_complete(version, %{
      completed_at: now(),
    }) |> Repo.update!
  end

  defp create_version!(file_path, nil) do
    sha256 =  :crypto.hash(:sha256, File.read(file_path))

    {:ok, version} = RusherVersion.changeset_start(%{
      file_sha256: sha256,
      name: sha256
    })
      |> Repo.insert!

    version
  end

  defp create_version!(file_path, name) do
    sha256 =  :crypto.hash(:sha256, File.read(file_path))
    
    {:ok, version} = RusherVersion.changeset_start(%{
      file_sha256: sha256,
      name: name
    })
      |> Repo.insert!

    version
  end

  defp process_rushers(version, file_path) do
    file_path
      |> read_file
      |> Enum.map(fn (data) ->
          import_rusher(version, data)
        end)
  end

  defp read_file(file_path) do
    {:ok, rusher_data} = File.read(file_path)

    {:ok, decoded} = JSON.decode!(rusher_data)
    decoded
  end

  defp import_rusher(version, %{} = data) do
    Rusher.changeset_import(%Rusher{}, %{
      rusher_version: version,
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
    })
  end

  defp read_lng(field) do
    Integer.parse(Regex.scan(~r/^(\d+)/, field))
  end

  defp read_lng_td(field) do
    field.ends_with?(["T", "t"])
  end

  defp now do
    DateTime.now("Etc/UTC")
  end

end
