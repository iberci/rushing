defmodule NflRusherWeb.VersionChannel do
  use NflRusherWeb, :channel

  def join("versions.join", _message, socket) do
    {:ok, socket}
  end

end
