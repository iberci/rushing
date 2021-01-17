defmodule NflRusher.RusherTest do
  use NflRusher.DataCase, async: true

  alias NflRusher.Rusher
  import Rusher

  test "rusher names with multiple names" do
    three_named_rusher = %{sample_rusher() | player: "First Middle Last"}
    
    cs = changeset_import(%Rusher{}, three_named_rusher)

    assert Enum.count(get_field(cs, :rusher_names)) == 3
  end

  test "rusher crud operations" do
    cs = changeset_import(%Rusher{}, sample_rusher())

    case Repo.insert(cs) do
      {:error, msg} -> flunk(msg)
      {:ok, rec} -> assert (from r in Rusher, where: r.id == ^(rec.id)) |> Repo.one
    end
  end

  defp sample_rusher do
    %{
      player: "First Last",
      att: 5,
      att_g: 1.2,
      fd: 2,
      fd_p: 3.3,
      fum: 2,
      plus_20: 1,
      plus_40: 0,
      pos: "QB",
      td: 3,
      yds: 5,
      yds_g: 2.1,
      team: "sf",
      lng: 6
    }
  end
end
