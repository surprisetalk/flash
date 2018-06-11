defmodule Flash.CampaignsTest do
  use Flash.DataCase

  alias Flash.Campaigns

  describe "card" do
    alias Flash.Campaigns.Cards

    @valid_attrs %{body: %{}}
    @update_attrs %{body: %{}}
    @invalid_attrs %{body: nil}

    def cards_fixture(attrs \\ %{}) do
      {:ok, cards} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Campaigns.create_cards()

      cards
    end

    test "list_card/0 returns all card" do
      cards = cards_fixture()
      assert Campaigns.list_card() == [cards]
    end

    test "get_cards!/1 returns the cards with given id" do
      cards = cards_fixture()
      assert Campaigns.get_cards!(cards.id) == cards
    end

    test "create_cards/1 with valid data creates a cards" do
      assert {:ok, %Cards{} = cards} = Campaigns.create_cards(@valid_attrs)
      assert cards.body == %{}
    end

    test "create_cards/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaigns.create_cards(@invalid_attrs)
    end

    test "update_cards/2 with valid data updates the cards" do
      cards = cards_fixture()
      assert {:ok, cards} = Campaigns.update_cards(cards, @update_attrs)
      assert %Cards{} = cards
      assert cards.body == %{}
    end

    test "update_cards/2 with invalid data returns error changeset" do
      cards = cards_fixture()
      assert {:error, %Ecto.Changeset{}} = Campaigns.update_cards(cards, @invalid_attrs)
      assert cards == Campaigns.get_cards!(cards.id)
    end

    test "delete_cards/1 deletes the cards" do
      cards = cards_fixture()
      assert {:ok, %Cards{}} = Campaigns.delete_cards(cards)
      assert_raise Ecto.NoResultsError, fn -> Campaigns.get_cards!(cards.id) end
    end

    test "change_cards/1 returns a cards changeset" do
      cards = cards_fixture()
      assert %Ecto.Changeset{} = Campaigns.change_cards(cards)
    end
  end

  describe "cards" do
    alias Flash.Campaigns.Card

    @valid_attrs %{body: %{}}
    @update_attrs %{body: %{}}
    @invalid_attrs %{body: nil}

    def card_fixture(attrs \\ %{}) do
      {:ok, card} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Campaigns.create_card()

      card
    end

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Campaigns.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Campaigns.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      assert {:ok, %Card{} = card} = Campaigns.create_card(@valid_attrs)
      assert card.body == %{}
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaigns.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      assert {:ok, card} = Campaigns.update_card(card, @update_attrs)
      assert %Card{} = card
      assert card.body == %{}
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Campaigns.update_card(card, @invalid_attrs)
      assert card == Campaigns.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Campaigns.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Campaigns.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Campaigns.change_card(card)
    end
  end

  describe "facts" do
    alias Flash.Campaigns.Fact

    @valid_attrs %{body: [], difficulty: 120.5, priority: 120.5, review_frequency: 120.5}
    @update_attrs %{body: [], difficulty: 456.7, priority: 456.7, review_frequency: 456.7}
    @invalid_attrs %{body: nil, difficulty: nil, priority: nil, review_frequency: nil}

    def fact_fixture(attrs \\ %{}) do
      {:ok, fact} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Campaigns.create_fact()

      fact
    end

    test "list_facts/0 returns all facts" do
      fact = fact_fixture()
      assert Campaigns.list_facts() == [fact]
    end

    test "get_fact!/1 returns the fact with given id" do
      fact = fact_fixture()
      assert Campaigns.get_fact!(fact.id) == fact
    end

    test "create_fact/1 with valid data creates a fact" do
      assert {:ok, %Fact{} = fact} = Campaigns.create_fact(@valid_attrs)
      assert fact.body == []
      assert fact.difficulty == 120.5
      assert fact.priority == 120.5
      assert fact.review_frequency == 120.5
    end

    test "create_fact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaigns.create_fact(@invalid_attrs)
    end

    test "update_fact/2 with valid data updates the fact" do
      fact = fact_fixture()
      assert {:ok, fact} = Campaigns.update_fact(fact, @update_attrs)
      assert %Fact{} = fact
      assert fact.body == []
      assert fact.difficulty == 456.7
      assert fact.priority == 456.7
      assert fact.review_frequency == 456.7
    end

    test "update_fact/2 with invalid data returns error changeset" do
      fact = fact_fixture()
      assert {:error, %Ecto.Changeset{}} = Campaigns.update_fact(fact, @invalid_attrs)
      assert fact == Campaigns.get_fact!(fact.id)
    end

    test "delete_fact/1 deletes the fact" do
      fact = fact_fixture()
      assert {:ok, %Fact{}} = Campaigns.delete_fact(fact)
      assert_raise Ecto.NoResultsError, fn -> Campaigns.get_fact!(fact.id) end
    end

    test "change_fact/1 returns a fact changeset" do
      fact = fact_fixture()
      assert %Ecto.Changeset{} = Campaigns.change_fact(fact)
    end
  end

  describe "tasks" do
    alias Flash.Campaigns.Task

    @valid_attrs %{body: "some body", is_completed: true, priority: 120.5}
    @update_attrs %{body: "some updated body", is_completed: false, priority: 456.7}
    @invalid_attrs %{body: nil, is_completed: nil, priority: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Campaigns.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Campaigns.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Campaigns.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Campaigns.create_task(@valid_attrs)
      assert task.body == "some body"
      assert task.is_completed == true
      assert task.priority == 120.5
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaigns.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = Campaigns.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task.body == "some updated body"
      assert task.is_completed == false
      assert task.priority == 456.7
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Campaigns.update_task(task, @invalid_attrs)
      assert task == Campaigns.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Campaigns.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Campaigns.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Campaigns.change_task(task)
    end
  end
end
