defmodule NflRusher.JsonSerializerTest do
  use NflRusher.DataCase, async: true
  alias NflRusher.JsonSerializer

  @main_test_file "test/rushing.json"

  test "json async start serialization of valid file" do
    {:ok, _version} = JsonSerializer.import(@main_test_file, [])
  end


  test "json sync serialization of valid file" do
    {:ok, _version} = JsonSerializer.import(@main_test_file, acync: false)
  end
end
