class CreateMenuItems < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_items do |t|
      t.belongs_to :menu, null: false, foreign_key: true
      t.string :nome
      t.bigint :parent_id
      t.integer :indice
      t.string :tipo
      t.string :link
      t.string :rota

      t.timestamps
    end
  end
end
