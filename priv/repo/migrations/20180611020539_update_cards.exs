defmodule Flash.Repo.Migrations.UpdateCards do
  use Ecto.Migration

  def change do

    drop_if_exists table(:cards)

    execute """
      CREATE VIEW cards AS

      SELECT id
           , body
           , card_type

      FROM ( ( SELECT id
                    , body
                    , priority
                    , 'FACT' 
                        AS card_type
                 FROM facts
                 ORDER BY priority DESC
                        , RANDOM()
                 LIMIT 250
              )

           UNION

             ( SELECT id
                    , ARRAY[ body ] AS body
                    , priority * 2 
                        AS priority
                    , 'TASK' 
                        AS card_type
                 FROM tasks
                WHERE is_completed = FALSE
                ORDER BY priority DESC
                    , RANDOM()
             )
           )
        AS c

      ORDER BY priority DESC
             , RANDOM();
    """

  end
end
