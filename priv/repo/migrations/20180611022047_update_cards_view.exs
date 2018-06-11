defmodule Flash.Repo.Migrations.UpdateCardsView do
  use Ecto.Migration

  def change do

    execute "DROP VIEW IF EXISTS cards;"

    execute """
      CREATE VIEW cards AS

      SELECT id
           , body
           , card_type
           , updated_at
           , inserted_at

      FROM ( ( SELECT id
                    , body
                    , priority
                    , 'FACT' AS card_type
                    , updated_at
                    , inserted_at
                 FROM facts
                 ORDER BY priority DESC
                        , RANDOM()
                 LIMIT 250
              )

           UNION

             ( SELECT id
                    , ARRAY[ body ] AS body
                    , priority * 2 AS priority
                    , 'TASK' AS card_type
                    , updated_at
                    , inserted_at
                 FROM tasks
                WHERE is_completed = FALSE
             )
           )
        AS c

      ORDER BY priority DESC
             , RANDOM();
    """

  end
end
