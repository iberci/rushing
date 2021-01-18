defmodule NflRusher.RusherDataStub do

  alias NflRusher.JsonSerializer

  def entries(file_path \\ "test/rushing.json") do
    file_path
      |> File.read!
      |> JSON.decode!
  end

  def random_data(count \\ 1) do
    Enum.take_random(entries(), count)
  end

  def random_version() do
    now = DateTime.utc_now |> DateTime.truncate(:second)

    %NflRusher.RusherVersion{
      name: "Test Version",
      file_sha256: "****",
      inserted_at: now,
      updated_at: now
    }
  end

  def random_rushers(count \\ 1) do
    version = random_version()
    random_data(count)
      |> Enum.map(fn(x) -> JsonSerializer.build_rusher(x, version) end)
  end

  def random_rusher() do
    random_rushers(1) |> List.first
  end
end
