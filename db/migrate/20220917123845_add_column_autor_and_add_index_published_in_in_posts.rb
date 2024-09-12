class AddColumnAutorAndAddIndexPublishedInInPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :autor, :string
    add_index :posts, :published_in, unique: false
  end
end
