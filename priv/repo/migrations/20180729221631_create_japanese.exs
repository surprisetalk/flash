defmodule Flash.Repo.Migrations.CreateJapanese do
  use Ecto.Migration

  def change do
    create table(:facts_vocab_japanese) do
      add :core_index, :integer
      add :vocab_ko_index, :integer
      add :sent_ko_index, :integer
      add :new_opt_voc_index, :integer
      add :opt_voc_index, :integer
      add :opt_sen_index, :integer
      add :jlpt, :string
      add :vocab_expression, :string
      add :vocab_kana, :string
      add :vocab_meaning, :string
      add :vocab_sound_local, :string
      add :vocab_pos, :string
      add :sentence_expression, :text
      add :sentence_kana, :text
      add :sentence_meaning, :text
      add :sentence_sound_local, :string
      add :sentence_image_local, :string
      add :vocab_furigana, :string
      add :sentence_furigana, :text
      add :sentence_cloze, :text

      timestamps
    end
  end

end
