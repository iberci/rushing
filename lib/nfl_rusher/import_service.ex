defmodule NflRusher.ImportService do
  use GenServer

  @period 5000
  alias NflRusher.{JsonSerializer, RusherVersion}

  alias NflRusher.Repo
  import Ecto.Query


  def start_link(options) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  def init(_state) do
    Process.send_after(self(), :poll, @period)

    {:ok, _state}
  end

  def handle_info(:poll, state) do
    process!()

    Process.send_after(self(), :poll, @period)
    {:ok, state}
  end

  defp process! do
    awaiting_processing()
      |> JsonSerializer.process_version!
  end

  def awaiting_processing do
    (from RusherVersion,
      where: is_nil(:completed_at),
      where: is_nil(:faulted_at),
      where: is_nil(:started_at))
      |> Repo.all
  end

  def handle_cast(:process, _from, state) do
    process!()

    {:noreply, state}
  end

end
