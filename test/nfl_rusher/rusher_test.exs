defmodule NflRusher.RusherTest do
  use NflRusher.DataCase, async: true

  alias NflRusher.Rusher
  alias Ecto.Changeset

  test "more than 2 names" do
    assert 3 == "One Two Three"
      |> sample_rusher()
      |> Rusher.changeset()
      |> get_field(:rusher_names)
      |> Enum.count
  end

  test "2 character or smaller names get rejected" do
    assert 2 == "XX Two Three"
      |> sample_rusher()
      |> Rusher.changeset()
      |> Changeset.get_field(:rusher_names)
      |> Enum.count
 
  end

  test "ensure that all names are downcased" do
     assert ["cap", "mix"] == "CAP mIx"
      |> sample_rusher() 
      |> Rusher.changeset()
      |> get_field(:rusher_names)
      |> Enum.map(&(Map.get(&1, :index_name)))
  end

  test "rusher crud operations" do
    cs = sample_rusher()
      |> Rusher.changeset()

    case Repo.insert(cs) do
    {:ok, rusher} ->
      assert (from r in Rusher, where: r.id == ^(rusher.id)) |> Repo.one
    {:error, msg} ->
      flunk(msg)
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
      |> NflRusher.JsonService.build_rusher(sample_version)
  end

  defp sample_rusher() do
    sample_rusher("Joe Banyard")
  end

end
