defmodule TartuParking.PageController do
  use TartuParking.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
