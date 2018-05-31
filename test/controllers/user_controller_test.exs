defmodule Flash.UserControllerTest do
  use Flash.ConnCase

  test "#me requires a login", %{conn: conn} do
    conn = get(conn, user_path(conn, :me))

    assert json_response(conn, 401) ==
             Flash.AuthErrorHandler.unauthenticated_response()
  end

  test "#me renders the user" do
    user = insert(:user)
    conn = guardian_login(user)

    conn = get(conn, user_path(conn, :me))

    assert json_response(conn, 200) == render_json("show.json", user: user)
  end

  # see https://robots.thoughtbot.com/building-a-phoenix-json-api
  defp render_json(template, assigns) do
    assigns = Map.new(assigns)

    Flash.UserView.render(template, assigns)
    |> Poison.encode!()
    |> Poison.decode!()
  end
end
