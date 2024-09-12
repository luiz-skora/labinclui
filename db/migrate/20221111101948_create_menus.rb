class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus do |t|
      t.belongs_to :app, null: false, foreign_key: true
      t.string :nome
      t.string :identifier

      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
