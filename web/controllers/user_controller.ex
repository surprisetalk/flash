defmodule Flash.UserController do
  use Flash.Web, :controller
  use Guardian.Phoenix.Controller

  plug(Guardian.Plug.EnsureAuthenticated, handler: Flash.AuthErrorHandler)

  def me(conn, _params, user, _claims) do
    render(conn, "show.json", user: user)
  end
end
