defmodule NflRusherWeb.PageController do
  use NflRusherWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
