class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.belongs_to :app, null: false, foreign_key: true
      t.string :nome
      t.string :identifier

      t.timestamps
    end
  end
end
