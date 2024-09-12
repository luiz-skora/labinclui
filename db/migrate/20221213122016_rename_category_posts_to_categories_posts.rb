class RenameCategoryPostsToCategoriesPosts < ActiveRecord::Migration[7.0]
  def change
    rename_table :category_posts, :categories_posts
  end
end
