class CreateModuloEvaluations < ActiveRecord::Migration[7.0]
  def change
    create_table :modulo_evaluations do |t|
      t.belongs_to :curso_modulo, null: false, foreign_key: true
      t.bigint :aula_id
      t.string :tipo
      t.integer :indice

      t.timestamps
    end
  end
end
