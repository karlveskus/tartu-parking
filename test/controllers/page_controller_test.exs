defmodule TartuParking.PageControllerTest do
  use TartuParking.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "<main role=\"main\">\n<div id=\"parking-app\">"
  end
end
