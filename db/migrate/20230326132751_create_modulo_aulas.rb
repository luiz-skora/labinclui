class CreateModuloAulas < ActiveRecord::Migration[7.0]
  def change
    create_table :modulo_aulas do |t|
      t.belongs_to :curso_modulo, null: false, foreign_key: true
      t.string :nome
      t.integer :indice
      t.string :tipo
      t.boolean :ativo, default: true

      t.timestamps
    end
  end
end
