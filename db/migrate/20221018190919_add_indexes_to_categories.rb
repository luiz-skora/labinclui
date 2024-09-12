class AddIndexesToCategories < ActiveRecord::Migration[7.0]
  def change
    add_index :categories, :nome, unique: true
    add_index :categories, :identifier, unique: true
  end
end
