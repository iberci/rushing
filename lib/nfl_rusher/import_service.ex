defmodule NflRusher.ImportService do
  use GenServer

  @period 60000
  alias NflRusher.{JsonSerializer, RusherVersion}

  alias NflRusher.Repo
  import Ecto.Query


  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    Process.send_after(self(), :poll, @period)

    {:ok, state}
  end

  def handle_info(:poll, state) do
    process!()

    Process.send_after(self(), :poll, @period)
    {:noreply, state}
  end

  defp process! do
    awaiting_processing()
      |> Enum.map(&JsonSerializer.process_version!/1)
  end

  def awaiting_processing do
    (from rv in RusherVersion,
      where: is_nil(rv.completed_at),
      where: is_nil(rv.faulted_at),
      where: is_nil(rv.started_at))
      |> Repo.all
  end

  def handle_cast(:process, _from, state) do
    process!()

    {:noreply, state}
  end

end
