defmodule FlashWeb.CardController do
  use FlashWeb, :controller

  alias Flash.Campaigns
  alias Flash.Campaigns.Card

  action_fallback FlashWeb.FallbackController

  def index(conn, _params) do
    cards = Campaigns.list_cards()
    render(conn, "index.json", cards: cards)
  end

  def create(conn, %{"card" => card_params}) do
    with {:ok, %Card{} = card} <- Campaigns.create_card(card_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", card_path(conn, :show, card))
      |> render("show.json", card: card)
    end
  end

  def show(conn, %{"id" => id}) do
    card = Campaigns.get_card!(id)
    render(conn, "show.json", card: card)
  end
end
