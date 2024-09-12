class CreateCursos < ActiveRecord::Migration[7.0]
  def change
    create_table :cursos do |t|
      t.string :nome
      t.string :identifier
      t.bigint :cooredenador_id
      t.integer :horas
      t.string :tipo
      t.boolean :ativo, default: true

      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
