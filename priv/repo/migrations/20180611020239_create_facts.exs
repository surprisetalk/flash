defmodule Flash.Repo.Migrations.CreateFacts do
  use Ecto.Migration

  def change do
    create table(:facts) do
      add :body, {:array, :text}, null: false
      add :difficulty, :float, null: false, default: 0.3
      add :review_frequency, :float, null: false, default: 10
          # Number of days between reviews.
      add :priority, :float, null: false, default: 1

      timestamps()
    end

  end
end
