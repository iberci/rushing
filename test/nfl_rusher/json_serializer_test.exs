defmodule NflRusher.JsonSerializerTest do
  use NflRusher.DataCase, async: true
  alias NflRusher.JsonSerializer

  test "json serialization of expected file" do
    {:ok, _version} = JsonSerializer.import("rusher.json")
  end
end
