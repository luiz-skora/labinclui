class AddIndexToPage < ActiveRecord::Migration[7.0]
  def change
    add_index :pages, :identifier, unique: true
  end
end
