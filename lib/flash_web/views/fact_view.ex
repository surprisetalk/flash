defmodule FlashWeb.FactView do
  use FlashWeb, :view
  alias FlashWeb.FactView

  def render("index.json", %{facts: facts}) do
    %{data: render_many(facts, FactView, "fact.json")}
  end

  def render("show.json", %{fact: fact}) do
    %{data: render_one(fact, FactView, "fact.json")}
  end

  def render("fact.json", %{fact: fact}) do
    %{id: fact.id,
      body: fact.body,
      difficulty: fact.difficulty,
      review_frequency: fact.review_frequency,
      priority: fact.priority}
  end
end
