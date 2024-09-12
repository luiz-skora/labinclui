class CreateCursoModulos < ActiveRecord::Migration[7.0]
  def change
    create_table :curso_modulos do |t|
      t.belongs_to :curso, null: false, foreign_key: true
      t.string :nome
      t.bigint :coordenador_id
      t.integer :indice
      t.boolean :ativo, default: true

      t.timestamps
    end
  end
end
