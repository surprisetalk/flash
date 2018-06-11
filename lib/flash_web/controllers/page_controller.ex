defmodule FlashWeb.PageController do
  use FlashWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
