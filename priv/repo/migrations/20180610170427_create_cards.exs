defmodule Flash.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :body, :map

      timestamps()
    end

  end
end
