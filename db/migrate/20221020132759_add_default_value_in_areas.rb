class AddDefaultValueInAreas < ActiveRecord::Migration[7.0]
  def change
    change_column :areas, :device, :string, default: "Desktop"
    add_index :areas, :identifier, unique: true
  end
end
