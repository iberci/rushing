defmodule NflRusher.RusherTest do
  use NflRusher.DataCase, async: true

  alias NflRusher.Rusher
  import Rusher

  test "rusher names with multiple names" do
    assert 3 ==  changeset(sample_rusher("First Middle Last"))
      |> get_field(:rusher_names)
      |> Enum.count
  end

  test "rusher crud operations" do
    cs = changeset(sample_rusher())

    case Repo.insert(cs) do
      {:error, msg} -> flunk(msg)
      {:ok, rec} -> assert (from r in Rusher, where: r.id == ^(rec.id)) |> Repo.one
    end
  end

  @sample_data %{
    "1st" => 0,
    "1st%" => 0,
    "20+" => 0,
    "40+" => 0,
    "Att" =>  2,
    "Att/G" => 2,
    "Avg" => 3.5,
    "FUM" => 0,
    "Lng" => "7",
    "Player" => "Joe Banyard",
    "Pos" => "RB",
    "TD" => 0,
    "Team" => "JAX",
    "Yds" => 7,
    "Yds/G" => 7
  }

  def sample_data, do: @sample_data

  defp sample_rusher(name) do
    now = DateTime.utc_now |> DateTime.truncate(:second)
    sample_version = %NflRusher.RusherVersion{
      name: "Test Version",
      file_sha256: "****",
      inserted_at: now,
      updated_at: now
    } |> Repo.insert!

    @sample_data
      |> Map.put("Player", name)
      |> NflRusher.JsonSerializer.build_rusher(sample_version)
  end

  defp sample_rusher() do
    sample_rusher("Joe Banyard")
  end

end
