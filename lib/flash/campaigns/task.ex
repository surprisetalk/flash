defmodule Flash.Campaigns.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :body, :string
    field :is_completed, :boolean, default: false
    field :priority, :float

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:body, :priority, :is_completed])
    |> validate_required([:body, :priority, :is_completed])
  end
end
