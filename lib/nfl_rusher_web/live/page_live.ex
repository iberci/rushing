defmodule NflRusherWeb.PageLive do
  use NflRusherWeb, :live_view
  alias NflRusher.{FileImporter, Repo, RusherVersion, Rusher}
  import Ecto.Query
  
  
  @imports_folder "imports/"

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
      socket
        |> assign(version: nil)
	|> assign(rusher_count: 0)
	|> assign(uploaded_files: [])
	|> allow_upload(:import_file, accept: ~w(.json))
    }
  end

  @impl true
  def handle_event("import_version", %{"form" => %{"name" => name}}, socket) do
    consume_uploaded_entries(socket, :import_file, fn %{path: path}, _entry -> 
      
      import_path = cp_path(path)
      File.cp(path, import_path)

      Task.async(fn ->
        {:ok, version} = FileImporter.import_file(path: import_path, name: name)
        assign(socket, :version, version)
      end)

    end)

    {:noreply, socket}
  end

  def handle_event("form_change", _params, socket),  do: {:noreply, socket}

  defp cp_path(path) do
    Path.join(@imports_folder, Path.basename(path))
  end

  def count_rushers(nil), do: 0

  def count_rushers(version_id) do
    (from r in Rusher,
    join: rv in assoc(r, :rusher_version), on: r.rusher_version_id == rv.id,
    where: rv.id == ^version_id,
    select: count(r))
     |> Repo.one

  end

end
