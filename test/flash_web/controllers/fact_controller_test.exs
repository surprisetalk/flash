defmodule FlashWeb.FactControllerTest do
  use FlashWeb.ConnCase

  alias Flash.Campaigns
  alias Flash.Campaigns.Fact

  @create_attrs %{body: [], difficulty: 120.5, priority: 120.5, review_frequency: 120.5}
  @update_attrs %{body: [], difficulty: 456.7, priority: 456.7, review_frequency: 456.7}
  @invalid_attrs %{body: nil, difficulty: nil, priority: nil, review_frequency: nil}

  def fixture(:fact) do
    {:ok, fact} = Campaigns.create_fact(@create_attrs)
    fact
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all facts", %{conn: conn} do
      conn = get conn, fact_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create fact" do
    test "renders fact when data is valid", %{conn: conn} do
      conn = post conn, fact_path(conn, :create), fact: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, fact_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "body" => [],
        "difficulty" => 120.5,
        "priority" => 120.5,
        "review_frequency" => 120.5}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, fact_path(conn, :create), fact: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update fact" do
    setup [:create_fact]

    test "renders fact when data is valid", %{conn: conn, fact: %Fact{id: id} = fact} do
      conn = put conn, fact_path(conn, :update, fact), fact: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, fact_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "body" => [],
        "difficulty" => 456.7,
        "priority" => 456.7,
        "review_frequency" => 456.7}
    end

    test "renders errors when data is invalid", %{conn: conn, fact: fact} do
      conn = put conn, fact_path(conn, :update, fact), fact: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete fact" do
    setup [:create_fact]

    test "deletes chosen fact", %{conn: conn, fact: fact} do
      conn = delete conn, fact_path(conn, :delete, fact)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, fact_path(conn, :show, fact)
      end
    end
  end

  defp create_fact(_) do
    fact = fixture(:fact)
    {:ok, fact: fact}
  end
end
