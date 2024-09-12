class AddOriginToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :origin, :string, default: 'App'
  end
end
