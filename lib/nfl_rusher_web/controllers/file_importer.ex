defmodule NflRusherWeb.FileImporter do
  use NflRusherWeb, :controller
  
  alias NflRusher.FileImporter, as: Importer

  def import_file(conn, %{"form" => form} = params) do

    {:ok, _version} = form["file"].path
      |> Importer.import_file(name: form["name"])

    redirect(conn, to: "/api/graphiql")
  end
end
