defmodule NflRusherWeb.PageLive do
  use NflRusherWeb, :live_view
  alias NflRusher.{Repo, RusherVersion, Rusher}
  import Ecto.Query

  @impl true
  def mount(_params, _session, socket) do
    v = current_version()
    {:ok, assign(socket, version: v , rusher_count: count_rushers(v.id))}
  end

  @impl true
  def handle_event("new_version", %{version: version}, socket) do
    {:noreply, assign(socket, current_version: version, rusher_count: count_rushers(version.id))}
  end

  def current_version() do
    (from rv in RusherVersion,
      where: not(is_nil(rv.completed_at)),
      order_by: [desc: rv.completed_at],
      limit: 1)
      |> Repo.one
  end

  def count_rushers(nil), do: 0

  def count_rushers(version_id) do
    (from r in Rusher,
    join: rv in assoc(r, :rusher_version), on: r.rusher_version_id == rv.id,
    where: rv.id == ^version_id,
    select: count(r))
     |> Repo.one

  end

  def import_version() do
  end

end
