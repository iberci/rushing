defmodule NflRusherWeb.PageLive do
  use NflRusherWeb, :live_view
  alias NflRusher.{FileImporter, Repo, RusherVersion, Rusher}
  import Ecto.Query

  @imports_folder "imports/"

  @impl true
  def mount(_params, _session, socket) do

    {:ok, socket
      |> assign_version(latest_version())
      |> assign(uploaded_files: [])
      |> allow_upload(:import_file, accept: ~w(.json), max_entries: 1)
    }
  end

  defp assign_version(socket, nil) do
    socket
      |> assign(%{
        version: nil,
	rusher_count: 0,
	name: nil,
	started_at: nil,
	completed_at: nil
      })
  end

  defp assign_version(socket, version) do
    socket
      |> assign(%{
        version: version,
	rusher_count: count_rushers(version.id),
	name: version.name,
	started_at: time_format(version.started_at),
	completed_at: time_format(version.completed_at)
      })
  end

  defp time_format(%DateTime{} = t), do: DateTime.truncate(t, :second)
  defp time_format(_), do: ""

  @impl true
  def handle_event("import_version", %{"form" => %{"name" => name}}, socket) do
    pid = self()
    consume_uploaded_entries(socket, :import_file, fn %{path: path}, _entry -> 
      
      assign(socket, :name, name)
      import_path = cp_path(path)
      File.cp(path, import_path)

      Task.start(fn ->
        {:ok, version} = FileImporter.import_file(path: import_path, name: name)
	send(pid, %{version: version})
      end)

    end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("form_change", %{"form" => %{"name" => name}}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{version: version}, socket) do
     
    {:noreply, socket
       |> assign_version(version)
       |> redirect(to: "/api/graphiql")
    }
  end

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

  def latest_version() do
    (from r in RusherVersion,
      where: not(is_nil(r.completed_at)), 
      order_by: [desc: r.completed_at],
      limit: 1
    ) |> Repo.one()
  end

end
