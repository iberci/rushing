defmodule NflRusher.JsonSerializer do

  alias NflRusher.Rusher
  alias NflRusher.{Repo, RusherVersion}
  alias Ecto.Changeset

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
    RusherVersion.changeset_complete(version) |> Repo.update!
  end

  defp file_to_sha256(file_path) do
    # https://www.poeticoding.com/hashing-a-file-in-elixir/
    hash_ref = :crypto.hash_init(:sha256)
    
    File.stream!(file_path)
      |> Enum.reduce(hash_ref, fn chunk, prev_ref-> 
        :crypto.hash_update(prev_ref, chunk)
      end)
      |> :crypto.hash_final()
      |> Base.encode16()
      |> String.downcase()
  end

  defp create_version!(file_path, nil) do
    sha256 = file_to_sha256(file_path)

    RusherVersion.changeset_start(%RusherVersion{}, %{
      file_sha256: sha256,
      name: sha256
    })
      |> Repo.insert!
  end

  defp create_version!(file_path, name) do
    sha256 =  :crypto.hash(:sha256, File.read(file_path))
    
    {:ok, version} = RusherVersion.changeset_start(%RusherVersion{}, %{
      file_sha256: sha256,
      name: name
    })
      |> Repo.insert!

    version
  end

  defp process_rushers(version, file_path) do
    file_path
      |> read_file
      |> process_entries(version)
  end

  defp process_entry(data, version) do
    data 
      |> build_rusher(version)
      |> Rusher.changeset()
      |> Changeset.put_change(:rusher_version, version)
      |> Repo.insert!
  end

  defp process_entries(entries, version) do
    entries 
      |> Enum.map(&(process_entry(&1, version)))
  end

  defp read_file(file_path) do
    file_path
      |> File.read!
      |> JSON.decode!
  end

  def build_rusher(%{
    "1st" => fd,
    "1st%" => fd_p,
    "20+" => plus_20,
    "40+" => plus_40,
    "Att" => att,
    "Att/G" => att_g,
    "Avg" => avg,
    "FUM" => fum,
    "Lng" => lng,
    "Player" => player,
    "Pos" => pos,
    "TD" => td,
    "Team" => team,
    "Yds" => yds,
    "Yds/G" => yds_g
  }, version) do
    %Rusher{
      rusher_version: version,
      player: player,
      team: team,
      pos: pos,
      att: att,
      att_g: att_g/1,
      avg: avg/1,
      yds: read_yds(yds),
      yds_g: yds_g/1,
      td: td,
      lng: read_lng(lng),
      lng_td: read_lng_td(lng),
      fd: fd,
      fd_p: fd_p/1,
      plus_20: plus_20,
      plus_40: plus_40,
      fum: fum 
    }
  end

  defp read_yds(field) when is_number(field) do
    field
  end

  defp read_yds(field) do
    field
      |> String.replace(~r/[\s,]/, "")
      |> Integer.parse
      |> elem(0)
  end

  defp read_lng(field) when is_number(field) do
    field
  end

  defp read_lng(field) do
    field
      |> String.replace(~r/\D/, "")
      |> Integer.parse
      |> elem(0)
  end

  defp read_lng(field) do
    field
      |> Integer.parse
      |> elem(0)
  end

  defp read_lng_td(<<field>> <> "T") do
    true
  end

  defp read_lng_td(_) do
    false
  end
end
