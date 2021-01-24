defmodule NflRusherWeb.PageLive do
  use NflRusherWeb, :live_view
  alias NflRusher.{FileImporter, Repo, RusherVersion, Rusher}
  import Ecto.Query
  
  
  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

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
    files =  consume_uploaded_entries(socket, :import_file, fn %{path: path}, _entry -> 
    
      FileImporter.import_file(path, name: name)
    end)

    1 = files
    {:noreply, socket}
  end

  def handle_event("form_change", _arg, socket),  do: {:noreply, socket}

  def count_rushers(nil), do: 0

  def count_rushers(version_id) do
    (from r in Rusher,
    join: rv in assoc(r, :rusher_version), on: r.rusher_version_id == rv.id,
    where: rv.id == ^version_id,
    select: count(r))
     |> Repo.one

  end

end
