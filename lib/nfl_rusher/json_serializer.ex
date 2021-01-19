defmodule NflRusher.JsonSerializer do

  alias NflRusher.Rusher
  alias NflRusher.{Repo, RusherVersion}
  alias Ecto.Changeset


  def import_file(options) do
    import_path = options[:path]
      |> copy_file

    version =  create_version!(path: import_path)

    if Keyword.has_key?(options, :async) && !options[:async] do
      {:ok, process_version!(version)}
    else 
      {:ok, version}
    end
  end

  defp copy_file(file_path) do
    file_name = DateTime.utc_now
      |> DateTime.to_string 

    import_path =  "imports/"<>file_name

    File.cp(file_path, import_path)

    import_path
  end

  def process_version!(version) do
    try do
      version
        |> process_start!
        |> process_rushers!
	|> process_finish!
      {:ok, version}
    rescue
      e in RuntimeError ->
        process_error(version, e)
        {:error, e}
    end
  end

  defp process_error(version, e) do
    version
      |> report_fault(e.message)
  end

  defp report_fault(version, message) do
    RusherVersion.changeset_fault(version, %{
      faulted_reason: message
    }) |> Repo.update!
  end

  defp process_finish!(version) do
    File.rm version.import_path

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

  defp create_version!(path: path, name: name) do
    
    RusherVersion.changeset_create(%RusherVersion{}, %{
      file_sha256: file_to_sha256(path), 
      name: name,
      import_path: path 
    })
      |> Repo.insert!
  end

  defp create_version!(path: path) do
    create_version!(path: path, name: file_to_sha256(path))
  end

  defp process_start!(version) do
    version
      |> RusherVersion.changeset_start()
      |> Repo.update!
  end

  defp process_rushers!(version) do
    version.import_path
      |> read_file
      |> process_entries(version)

    version  
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

  defp read_lng_td(<<_field>> <> "T") do
    true
  end

  defp read_lng_td(_) do
    false
  end
end
