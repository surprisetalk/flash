defmodule FlashWeb.FactController do
  use FlashWeb, :controller

  alias Flash.Campaigns
  alias Flash.Campaigns.Fact

  action_fallback FlashWeb.FallbackController

  def index(conn, _params) do
    facts = Campaigns.list_facts()
    render(conn, "index.json", facts: facts)
  end

  def create(conn, %{"fact" => fact_params}) do
    with {:ok, %Fact{} = fact} <- Campaigns.create_fact(fact_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", fact_path(conn, :show, fact))
      |> render("show.json", fact: fact)
    end
  end

  def show(conn, %{"id" => id}) do
    fact = Campaigns.get_fact!(id)
    render(conn, "show.json", fact: fact)
  end

  def update(conn, %{"id" => id, "fact" => fact_params}) do
    fact = Campaigns.get_fact!(id)

    with {:ok, %Fact{} = fact} <- Campaigns.update_fact(fact, fact_params) do
      render(conn, "show.json", fact: fact)
    end
  end

  def delete(conn, %{"id" => id}) do
    fact = Campaigns.get_fact!(id)
    with {:ok, %Fact{}} <- Campaigns.delete_fact(fact) do
      send_resp(conn, :no_content, "")
    end
  end

  def update(conn, %{"id" => id, "score" => score}) do
    fact = Campaigns.get_fact!(id)

    priority =
    # 1.0 - 2.0
      case score > 0.6 do
        true -> min(2, Date.diff(Date.utc_today(), fact.updated_at) / fact.review_frequency)
        false -> 1
      end

    difficulty = priority / 17 * ( 8 - ( 9 * score ) ) |> max(0.0) |> min(1.0)
    # 0.0 - 0.47

    difficulty_weight = 3 - ( 1.7 * difficulty )
    # 2.2 - 3.0

    review_frequency = 
    # 0.2 - 5.0
      case score > 0.6 do
        true -> 1 + ( difficulty_weight - 1 ) * priority
        false -> min( 1, 1 / ( difficulty_weight * difficulty_weight ) )
      end

    new_fact = %{
      "priority": priority,
      "difficulty": difficulty,
      "review_frequency": review_frequency
    }
    
    # IO.inspect(%{
    #   "score": score,
    #   "priority": priority,
    #   "difficulty": difficulty,
    #   "difficulty_weight": difficulty_weight,
    #   "review_frequency": review_frequency
    # })

    with {:ok, %Fact{} = fact} <- Campaigns.update_fact(fact, new_fact) do
      render(conn, "show.json", fact: fact)
    end
  end
end
