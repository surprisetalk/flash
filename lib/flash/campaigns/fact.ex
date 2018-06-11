defmodule Flash.Campaigns.Fact do
  use Ecto.Schema
  import Ecto.Changeset


  schema "facts" do
    field :body, {:array, :string}
    field :difficulty, :float
    field :priority, :float
    field :review_frequency, :float

    timestamps()
  end

  @doc false
  def changeset(fact, attrs) do
    fact
    |> cast(attrs, [:body, :difficulty, :review_frequency, :priority])
    |> validate_required([:body, :difficulty, :review_frequency, :priority])
  end
end
