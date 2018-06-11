defmodule FlashWeb.CardsView do
  use FlashWeb, :view
  alias FlashWeb.CardsView

  def render("index.json", %{card: card}) do
    %{data: render_many(card, CardsView, "cards.json")}
  end

  def render("show.json", %{cards: cards}) do
    %{data: render_one(cards, CardsView, "cards.json")}
  end

  def render("cards.json", %{cards: cards}) do
    %{id: cards.id,
      body: cards.body}
  end
end
