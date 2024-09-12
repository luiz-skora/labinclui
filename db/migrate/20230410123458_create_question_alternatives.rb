class CreateQuestionAlternatives < ActiveRecord::Migration[7.0]
  def change
    create_table :question_alternatives do |t|
      t.belongs_to :evaluation_question, null: false, foreign_key: true
      t.integer :indice
      t.boolean :is_discursiva, default: false
      t.boolean :correta, default: false
      t.integer :min_words
      t.integer :max_words

      t.timestamps
    end
  end
end
