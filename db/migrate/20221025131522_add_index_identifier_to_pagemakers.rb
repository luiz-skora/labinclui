class AddIndexIdentifierToPagemakers < ActiveRecord::Migration[7.0]
  def change
    add_index :pagemakers, :identifier, unique: true
  end
end
