class AddIndexesInTagPosts < ActiveRecord::Migration[7.0]
  def change
    add_index :tag_posts, [:tag_id, :post_id], unique: true
  end
end
