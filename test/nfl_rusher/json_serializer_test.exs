defmodule NflRusher.JsonSerializerTest do
  use NflRusher.DataCase, async: true
  alias NflRusher.JsonSerializer

  @main_test_file "test/rushing.json"

  test "json serialization of expected file" do
    {:ok, _version} = JsonSerializer.import(@main_test_file)
  end
end
