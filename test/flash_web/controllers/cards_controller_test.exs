defmodule FlashWeb.CardsControllerTest do
  use FlashWeb.ConnCase

  alias Flash.Campaigns
  alias Flash.Campaigns.Cards

  @create_attrs %{body: %{}}
  @update_attrs %{body: %{}}
  @invalid_attrs %{body: nil}

  def fixture(:cards) do
    {:ok, cards} = Campaigns.create_cards(@create_attrs)
    cards
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all card", %{conn: conn} do
      conn = get conn, cards_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create cards" do
    test "renders cards when data is valid", %{conn: conn} do
      conn = post conn, cards_path(conn, :create), cards: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, cards_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "body" => %{}}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, cards_path(conn, :create), cards: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update cards" do
    setup [:create_cards]

    test "renders cards when data is valid", %{conn: conn, cards: %Cards{id: id} = cards} do
      conn = put conn, cards_path(conn, :update, cards), cards: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, cards_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "body" => %{}}
    end

    test "renders errors when data is invalid", %{conn: conn, cards: cards} do
      conn = put conn, cards_path(conn, :update, cards), cards: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete cards" do
    setup [:create_cards]

    test "deletes chosen cards", %{conn: conn, cards: cards} do
      conn = delete conn, cards_path(conn, :delete, cards)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, cards_path(conn, :show, cards)
      end
    end
  end

  defp create_cards(_) do
    cards = fixture(:cards)
    {:ok, cards: cards}
  end
end
