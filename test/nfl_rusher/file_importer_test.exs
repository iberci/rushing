defmodule NflRusher.FileImporterTest do
  use NflRusher.DataCase, async: true
  alias NflRusher.{RusherVersion, FileImporter}

  @main_test_file "test/rushing.json"

  test "json async start serialization of valid file" do
    {:ok, %Task{}} = FileImporter.import_file(@main_test_file)
  end

  test "json sync serialization of valid file" do
    {:ok, %RusherVersion{}} = FileImporter.import_file(@main_test_file, async: false)
  end

end
