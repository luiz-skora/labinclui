class CreateAulaPaginas < ActiveRecord::Migration[7.0]
  def change
    create_table :aula_paginas do |t|
      t.belongs_to :modulo_aula, null: false, foreign_key: true
      t.integer :indice
      t.string :google_doc

      t.timestamps
    end
  end
end
