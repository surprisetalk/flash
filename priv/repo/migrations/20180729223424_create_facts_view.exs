defmodule Flash.Repo.Migrations.CreateFactsView do
  use Ecto.Migration

  def change do
    
    execute "DROP VIEW IF EXISTS cards;"

    alter table(:facts) do
      remove :body
    end

    create table(:facts_general) do
      add :fact_id, references(:facts), null: false
      add :body, {:array, :text}, null: false
      add :hints, {:array, :text}, null: false, default: []

      timestamps()
    end

    alter table(:facts_vocab_japanese) do
      add :fact_id, references(:facts)
    end

    execute """
      INSERT INTO facts
      ( id
      , difficulty
      , review_frequency
      , priority
      , inserted_at
      , updated_at
      )
      SELECT id
           , 0.3
           , 10
           , 1
           , NOW()
           , NOW()
      FROM facts_vocab_japanese
      ON CONFLICT (id) DO NOTHING
    """

    execute """
      UPDATE facts_vocab_japanese
      SET fact_id = id
    """

    execute """
      CREATE VIEW cards AS

      SELECT id
           , body
           , hints
           , priority
           , card_type
           , updated_at
           , inserted_at

      FROM ( ( SELECT f.id
                    , fg.body
                    , fg.hints
                    , f.priority
                    , 'FACT' AS card_type
                    , f.updated_at
                    , f.inserted_at
                 FROM facts AS f
                 INNER JOIN facts_general AS fg
                   ON f.id = fg.fact_id
                 ORDER BY priority DESC
                        , RANDOM()
              )

           UNION

             ( SELECT f.id
                    , ARRAY
                      [ fvj.vocab_expression
                      , fvj.vocab_meaning
                      , fvj.vocab_sound_local
                      ] AS body
                    , ARRAY
                      [ ''
                      , fvj.sentence_kana
                      , fvj.sentence_meaning
                      ] AS hints
                    , f.priority
                    , 'FACT' AS card_type
                    , f.updated_at
                    , f.inserted_at
                 FROM facts AS f
                 INNER JOIN facts_vocab_japanese AS fvj
                   ON f.id = fvj.fact_id
                 WHERE jlpt = 'JLPT0'
                 ORDER BY priority DESC
                        , RANDOM()
              )

           UNION

             ( SELECT id
                    , ARRAY[ body ] AS body
                    , '{}' AS hints
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
             , RANDOM()
      LIMIT 1000
    """

  end
end
