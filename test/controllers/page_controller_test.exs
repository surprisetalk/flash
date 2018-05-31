defmodule Flash.PageControllerTest do
  use Flash.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "elm-container"
  end
end
