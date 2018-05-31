defmodule Flash.AuthErrorHandlerTest do
  use Flash.ConnCase

  alias Flash.AuthErrorHandler

  test "unauthenticated error handler", %{conn: conn} do
    conn = AuthErrorHandler.unauthenticated(conn, %{})
    assert json_response(conn, 401) == %{"error" => "Unauthorized!"}
  end
end
