class CreateEvaluationQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :evaluation_questions do |t|
      t.belongs_to :modulo_evaluation, null: false, foreign_key: true
      t.integer :indice
      t.string :tipo
      t.integer :peso

      t.timestamps
    end
  end
end
