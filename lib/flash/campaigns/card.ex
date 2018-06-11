defmodule Flash.Campaigns.Card do
  use Ecto.Schema
  import Ecto.Changeset


  schema "cards" do
    field :body, {:array, :string}
    field :card_type, :string

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:body, :card_type])
    |> validate_required([:body, :card_type])
  end
end
