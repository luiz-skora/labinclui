class AddIndexesInCategoryPosts < ActiveRecord::Migration[7.0]
  def change
    add_index :category_posts, [:category_id, :post_id], unique: true
  end
end
