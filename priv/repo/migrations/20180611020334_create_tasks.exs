defmodule Flash.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :body, :text, null: false
      add :priority, :float, null: false, default: 0.5
      add :is_completed, :boolean, null: false, default: false

      timestamps()
    end

  end
end
