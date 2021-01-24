defmodule NflRusher.FileImporterTest do
  use NflRusher.DataCase, async: true
  alias NflRusher.{RusherVersion, FileImporter}

  @main_test_file "test/rushing.json"

  test "json serialization of valid file" do

    test_name = "test"
    {:ok, %RusherVersion{} = v} = FileImporter.import_file(path: @main_test_file, name: test_name)

    assert v.name == "test"
  end


  test "json serialization no name" do

    {:ok, %RusherVersion{} = v} = FileImporter.import_file(path: @main_test_file)

    assert String.length(v.name) != 0
  end

end
